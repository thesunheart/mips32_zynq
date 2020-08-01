# mips32_zynq
mips32 based on zynq

2020年新工科联盟-Xilinx暑期学校（Summer School）项目

使用软件：Vivado 2018.3

板卡：ZYNQ7020

source中包含源码以及用于仿真的inst_rom.data文件，从文件中加载要运行的指令

项目概要：借助《自己动手写CPU》这本书和AZPR代码，采用MIPS32指令集架构，完成一个能实现基本功能的CPU内核并进行相关验证。

首先完成逻辑指令集的五级流水线功能，包括取指、译码、执行、访存、写回。

然后在此基础上拓展更多功能，依次完成移位、移动、算术、转移、加载存储指令，实现一个完整架构的CPU。

添加包括UART、总线等功能。

继续实现协处理器访问、异常相关和其他指令。

目前正在进行中。
