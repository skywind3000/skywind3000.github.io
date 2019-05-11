---
uuid: 2449
title: 如何用 C语言编译出一个不需要操作系统的程序
status: draft
categories: 编程技术
tags: cpp
date: 2018-01-03 21:18
slug: 
---
来个更短的，没有其他乱七八糟的东西，只有一个简短的 C文件，不需要 linux 环境：

miniboot.c

```cpp
asm(".long 0x1badb002, 0, (-(0x1badb002 + 0))");

unsigned char *videobuf = (unsigned char*)0xb8000;
const char *str = "Hello, World !! ";

int start_entry(void)
{
	int i;
	for (i = 0; str[i]; i++) {
		videobuf[i * 2 + 0] = str[i];
		videobuf[i * 2 + 1] = 0x17;
	}
	for (; i < 80 * 25; i++) {
		videobuf[i * 2 + 0] = ' ';
		videobuf[i * 2 + 1] = 0x17;
	}
	while (1) { }
	return 0;
}
```

编译：

```bash
gcc -c -fno-builtin -ffreestanding -nostdlib -m32 miniboot.c -o miniboot.o
ld -e start_entry -m elf_i386 -Ttext-seg=0x100000 miniboot.o -o miniboot.elf
```

运行：

```bash
qemu-system-i386 -kernel miniboot.elf
```

结果：



