import re
import random


class SimplePol:
    """
    Class to make from one asm file another one but polymorphic to the input file.
    """
    def __init__(self, path):
        """
        Initialisation of path to file and lists for parsing.
        :param path: string.
        """
        self.path = path
        self.content = list()
        self.mov_cmp_jmp_je_jk_lst = list()
        self.add_sub_lst = list()
        self.add_sub_lst_im = list()
        self.add_sub_lst_reg = list()
        self.register_lst = list()

    def reader(self):
        """
        Read asm file and parse it by \n.
        :return: None.
        """
        with open(self.path) as f:
            for line in f:
                self.content.append(line.strip().split('\n'))

    def parser(self, word, lst):
        """
        Find some command in the asm file.
        :param word: string
        :param lst: list of strings
        :return: None.
        """
        for i in range(len(self.content)):
            if re.match(word, self.content[i][0]):
                lst.append(self.content[i])

    def parser_register(self):
        """
        Find all registers that used in asm file.
        :return: None
        """
        for i in range(len(self.content)):
            length = len(self.content[i][0])
            register = str()
            while length != 0:
                if self.content[i][0][length-1] == ',':
                    while self.content[i][0][length-1] != ' ' and self.content[i][0][length-1] != '\t':
                        length -= 1
                        register += self.content[i][0][length-1]
                    break
                length -= 1
            if register:
                register = register[:-1]
                register = register[::-1]
                self.register_lst.append(register)
        self.register_lst = list(set(self.register_lst))

    def parser_commands(self):
        """
        Find all mov, cmp, jmp,je,jk commands in asm file.
        :return: None
        """
        self.parser(r"mov|cmp|jmp|je|jk", self.mov_cmp_jmp_je_jk_lst)

    def parser_add_sub(self):
        """
        Find all add and sub commands in asm file.
        :return: None
        """
        self.parser(r"add|sub", self.add_sub_lst)

    def classification_add_sub(self):
        """
        Function to divide to different lists add and sub command. Add and sub with
        immediate and add with register.
        :return: None
        """
        for i in range(len(self.add_sub_lst)):
            if re.search(r', ?[0-9]*', self.add_sub_lst[i][0]):
                self.add_sub_lst_im.append(self.add_sub_lst[i])
            else:
                self.add_sub_lst_reg.append(self.add_sub_lst[i])

    @staticmethod
    def number_division(number):
        """
        Return a random number where param number is sup.
        :param number: int
        :return: None
        """
        return random.randrange(number)

    @staticmethod
    def line_maker(line, number, reverse=False):
        """
        Function to generate new line of asm code with add or sub and new
        numeric value.
        :param line: string
        :param number: int
        :param reverse: bool
        :return: string
        """
        new_line = str()
        i = 0
        while line[i] != ',':
            new_line += line[i]
            i += 1
        new_line += ','
        new_line += str(number)
        if reverse and new_line[0] == 'a':
            new_line = list(new_line)
            new_line[0], new_line[1], new_line[2] = 's', 'u', 'b'
            new_line = ''.join(new_line)
        elif reverse and new_line[0] == 's':
            new_line = list(new_line)
            new_line[0], new_line[1], new_line[2] = 'a', 'a', 'd'
            new_line = ''.join(new_line)
        return new_line

    def nope_adder(self, element):
        """
        Add to asm code nop.
        :param element: list of elements
        :return: None
        """
        index = self.content.index(element)
        self.content.insert(index, ['nop'])

    def division_adder_im(self, element):
        """
        Extract a number from a line and choose how to divide it.
        :param element: list
        :return: None
        """
        length = len(element[0])
        number = str()
        while element[0][length - 1] != ',':
            number += element[0][length - 1]
            length -= 1
        number = int(number[::-1])
        div = self.number_division(number)
        choice = random.choice([1,2,3])
        if choice == 1:
            self.division_adder_im_2(element, div, number)
        elif choice == 2:
            self.division_adder_sub(element,div,number)
        else:
            self.division_adder_im_3(element, div, number)

    def division_adder_im_2(self, element, div, number):
        """
        Add to asm code divided command of add or sub like:
        add eax 5
        add eax 3
        Instead of add eax 8
        :param element: list
        :param div: number
        :param number: number
        :return: None
        """
        new_line = self.line_maker(element[0], div)
        self.content.insert(self.content.index(element), [new_line])
        self.content[self.content.index(element)] = \
            [self.line_maker(element[0], number - div)]

    def division_adder_im_3(self, element, div, number):
        """
        Add to asm code divided command of add or sub like:
        add eax 1
        add eax 4
        add eax 3
        Instead of add eax 8
        :param element: list
        :param div: number
        :param number: number
        :return: None
        """
        if div == 0:
            new_div = 0
        else:
            new_div = self.number_division(div)
        self.content.insert(self.content.index(element), [self.line_maker(element[0], new_div)])
        self.content.insert(self.content.index(element), [self.line_maker(element[0], div - new_div)])
        self.content[self.content.index(element)] = \
            [self.line_maker(element[0], number - div)]

    def division_adder_sub(self, element, div, number):
        """
        Function which transform single add or sub line.
        F.E.:
        Make from add eax, 10:
        add eax, 13
        sub eax, 3
        :param element: list of string
        :param div: number
        :param number: number
        :return: None
        """
        new_div = random.randint(number + 1,  number + div + 1)
        self.content.insert(self.content.index(element), [self.line_maker(element[0] , new_div)])
        self.content[self.content.index(element)] = \
            [self.line_maker(element[0], new_div - number, True)]

    def add_sub_adder(self, element):
        """
        Function which add two lines with add some number to eax and sub
        this number from eax register.
        :param element: list of elements
        :return: None
        """
        index = self.content.index(element)
        number = self.number_division(10)
        self.content.insert(index, ['add eax, {}'.format(str(number))])
        self.content.insert(index, ['sub eax, {}'.format(str(number))])

    def stack_adder(self, element):
        """
        Add to asm code push and pop of some register.
        :param element: list of elements
        :return: None
        """
        index = self.content.index(element)
        self.content.insert(index, ['push eax'])
        self.content.insert(index, ['pop eax'])

    def stack_nop_adder(self, element):
        """
        Add to code push pop of the register and nop between them.
        :param element: list of string
        :return: None
        """
        index = self.content.index(element)
        self.content.insert(index, ['push eax'])
        self.content.insert(index, ['nop'])
        self.content.insert(index, ['pop eax'])

    def commands_transformer(self):
        """
        Modify every mov, cmp, jmp, jk, je command.
        :return: None
        """
        for i in range(len(self.mov_cmp_jmp_je_jk_lst)):
            choice = random.choice([1, 2, 3, 4])
            if choice == 1:
                self.nope_adder(self.mov_cmp_jmp_je_jk_lst[i])
            elif choice == 2:
                self.add_sub_adder(self.mov_cmp_jmp_je_jk_lst[i])
            elif choice == 3:
                self.stack_nop_adder(self.mov_cmp_jmp_je_jk_lst[i])
            else:
                self.stack_adder(self.mov_cmp_jmp_je_jk_lst[i])

    def add_sub_transformer(self):
        """
        Modify every add and sub command.
        :return: None
        """
        for i in range(len(self.add_sub_lst_im)):
            choice = random.choice([1,2,3])
            if choice == 1:
                self.nope_adder(self.add_sub_lst_im[i])
            elif choice == 2:
                self.stack_adder(self.add_sub_lst_im[i])
            else:
                self.division_adder_im(self.add_sub_lst_im[i])
        for i in range(len(self.add_sub_lst_reg)):
            choice = random.choice([1, 2, 3])
            if choice == 1:
                self.nope_adder(self.add_sub_lst_reg[i])
            elif choice == 2:
                self.stack_adder(self.add_sub_lst_reg[i])
            else:
                self.add_sub_adder(self.add_sub_lst_reg[i])

    def polymorph(self):
        """
        Make code polymorphous and write it to new asm file.
        :return:  None
        """
        self.reader()
        self.parser_add_sub()
        self.parser_commands()
        self.parser_register()
        self.classification_add_sub()
        self.commands_transformer()
        self.add_sub_transformer()
        content = str()
        for i in range(len(self.content)):
            content += self.content[i][0]
            if i != len(self.content) - 1:
                content += '\n'
        with open("bubble_out.asm", 'w') as f:
            f.write(content)


if __name__ == "__main__":
    a = SimplePol("old_bubble.asm")
    a.polymorph()
    print(a.register_lst)
