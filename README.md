<h1 align="center">
  <a href="link_on_site">Polymorphic engine</a>
</h1>

<p align="center">
  <a title="Quickstart" href="#quickstart"><strong>Quickstart</strong></a>
  &#x2022;
  <a title="Documentation" href="#documentation"><strong>Documentation</strong></a>
  &#x2022;
</p>

![](https://img.shields.io/github/languages/code-size/lurak/Polymorphic_engine)
![](https://img.shields.io/github/last-commit/lurak/Polymorphic_engine)
![](https://img.shields.io/github/languages/count/lurak/Polymorphic_engine)

# Polymorphic engine
## First some history
First virus have no protection from av scanner. When av company catched virus they insert signature of this virus in database and av already new that this program is virus just with getting hash sum of the program.

So Virus Exchange makes disguise code to prevent this. Idea is encrypt virus! Now only decryptor is naked, so only decryptor needs be polymorphic. 
## Result
This project makes header-file (decryptor) polymorphic, body code is encrypted with simple xor-cipher, and python file makes this encrypting, polymorphism and 
merges this two files.
## Documentation :pencil2:
### Used polymorphic methods:
 - Adding nop.
 - Add push and pop register to the stack.
 - Adding push and pop  register in between them nop.
 - Adding on top of adding and subtracting the same random number from some register.
 - Divide addition / subtraction by addition / subtraction of 2 other numbers.
 - Dividing addition / subtraction by adding / subtracting 3 other numbers.
 - Divide addition / subtraction into successive addition of subtraction of other numbers.
 - Dividing when multiplying two numbers one of them by two others.
 - Replacement of registers at cmp.
 - Mul pattern.
 ### Encrypting:
Here we using xor-cipher, with ```0x8E4E54DE6596DAEC``` 8 byte key 
#### Without encrypting: 
![image](https://user-images.githubusercontent.com/44615981/84591698-30098f80-ae49-11ea-9500-b9db030b0afd.png?style=centerme) </br>
The body code in this program 52 nop (Opcode of the mnemonic nop is 90)
#### With encrypting:
![image](https://user-images.githubusercontent.com/44615981/84591944-f46fc500-ae4a-11ea-8d5c-0deff4e24191.png?style=centerme) </br>
So when program stats, first-things-first it decrypt body code and after run this decrypted code.
## Quickstart

### Prerequisites :page_with_curl:

- nasm-packages
- python3

### Installing :tongue:
```
$ git clone https://github.com/lurak/Polymorphic_engine
```
### Usage :zap:
  - Change ```src/bubble_sort.asm``` on some script 
  - Run main.py
#### REMARK 
The algorithm of decrypting assume that your program size divided by 8 (length of key), so if your code don't divides by 8
just add some ```nop``` to your program.   
### Authors
 - Ihor Titov (polymorphism)
 - Danylo Sluzhynskyi (encrypting)



