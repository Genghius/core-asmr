#About

A GNU inspired set of coreutils written in x86_64 assembly.

I started this to teach myself assembly, it isnt meant to be actually useful.

#Assemble

This will tell NASM to create the object file ready to be linked.

```sh
nasm -f elf64 file.asm -o file.o
```

This will link the file.

```sh
ld file.o -o file
```

And voila! you now have an executable.
