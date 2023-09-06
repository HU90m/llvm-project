# RUN: llvm-mc %s -triple=riscv32 -mattr=+xotbn -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+xotbn < %s \
# RUN:     | llvm-objdump --mattr=+xotbn -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s

# CHECK-ASM-AND-OBJ: bn.add t0, t1, t1
# CHECK-ASM: encoding: [0xab,0x02,0x63,0x00]
bn.add t0, t1, t1

# CHECK-ASM-AND-OBJ: bn.sub t0, t1, t1
# CHECK-ASM: encoding: [0xab,0x12,0x63,0x00]
bn.sub t0, t1, t1
