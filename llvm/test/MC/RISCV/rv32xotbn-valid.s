# RUN: llvm-mc %s -triple=riscv32 -mattr=+xotbn -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+xotbn < %s \
# RUN:     | llvm-objdump --mattr=+xotbn -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s

# CHECK-ASM-AND-OBJ: bn.add w0, w1, w31
bn.add w0, w1, w31

# CHECK-ASM-AND-OBJ: bn.sub w5, w6, w6
# CHECK-ASM: encoding: [0xab,0x12,0x63,0x00]
bn.sub w5, w6, w6
