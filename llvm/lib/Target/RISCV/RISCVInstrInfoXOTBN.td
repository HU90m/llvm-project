//===-- RISCVInstrInfoXOTBN.td --------------------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the vendor extensions defined for OTBN.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// XOTBN
//===----------------------------------------------------------------------===//

def OPC_BN_OP : RISCVOpcode<"BN_OP", 0b0101011>;

// no i256 type available, so using i128
def WR : RegisterClass<"RISCV", [i128], 32, (sequence "W%u", 0, 31)>;

def BNShiftArg : AsmOperandClass {
  let Name = "BNShiftArg";
  let RenderMethod = "addBNShiftArgOperands";
  let ParserMethod = "parseBNShiftArg";
  let IsOptional = 1;
  let DefaultMethod = "defaultBNShiftArgOp";
}

foreach n = 0-31 in {
  def "W" # n  : RISCVReg<n, "w" # n>;
}

let
    Predicates = [IsRV32, HasVendorXOTBN],
    DecoderNamespace = "XOTBN"
in {
  class RVInstBNBase<bits<3> funct3, RISCVOpcode opcode, dag outs,
                    dag ins, string opcodestr, string argstr>
      : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
    bit     fg;
    bit     st;
    bits<5> sb;
    bits<5> wrs2;
    bits<5> wrs1;
    bits<5> wrd;

    let Inst{31} = fg;
    let Inst{30} = st;
    let Inst{29-25} = sb;
    let Inst{24-20} = wrs2;
    let Inst{19-15} = wrs1;
    let Inst{14-12} = funct3;
    let Inst{11-7} = wrd;
    let Inst{6-0} = opcode.Value;
  }

  let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
  class ALU_bn<bits<3> funct3, string opcodestr, bit Commutable = 0>
      : RVInstBNBase<funct3, OPC_BN_OP, (outs WR:$wrd), (ins WR:$wrs1, WR:$wrs2),
                opcodestr, "$wrd, $wrs1, $wrs2"> {
    let isCommutable = Commutable;
    let fg = 0;
    let st = 0;
    let sb = 0;
  }

  def BN_ADD : ALU_bn<0b000, "bn.add", Commutable=1>;
  def BN_SUB : ALU_bn<0b001, "bn.sub", Commutable=0>;
} // DecoderNamespace = "XOTBN"
