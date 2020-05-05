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
        self.counter = 0
        self.content = list()
        self.mov_lst = list()
        self.add_sub_lst = list()
        self.add_sub_lst_im = list()
        self.add_sub_lst_reg = list()

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
                lst.append((self.content[i][0], i))

    def parser_mov(self):
        """
        Find all mov commands in asm file.
        :return: None
        """
        self.parser("mov", self.mov_lst)

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
    def line_maker(line, number):
        """
        Function to generate new line of asm code with add or sub and new
        numeric value.
        :param line: string
        :param number: int
        :return: string
        """
        new_line = str()
        i = 0
        while line[i] != ',':
            new_line += line[i]
            i += 1
        new_line += ','
        new_line += str(number)
        return new_line

    def nope_adder(self, element):
        """
        Add to asm code nop.
        :param element: tuple of elements
        :return: None
        """
        index = element[1]
        self.content.insert(index + self.counter, ['nop'])
        self.counter += 1

    def division_adder_im(self, element):
        """
        Add to asm code divided command of add or sub like:
        add eax 5
        add eax 3
        Instead of add eax 8
        :param element: tuple of elements
        :return: None
        """
        length = len(element[0])
        number = str()
        while element[0][length - 1] != ',':
            number += element[0][length - 1]
            length -= 1
        number = int(number[::-1])
        div = self.number_division(number)
        new_line = self.line_maker(element[0], div)
        self.content.insert(element[1] + self.counter, [new_line])
        self.counter += 1
        self.content[self.content.index([element[0]])] = \
            [self.line_maker(element[0], number - div)]

    def add_sub_adder(self, element):
        """
        Function which add two lines with add some number to eax and sub
        this number from eax register.
        :param element: tuple of elements
        :return: None
        """
        index = element[1]
        self.content.insert(index + self.counter, ['add eax, 8'])
        self.counter += 1
        self.content.insert(index + self.content, ['sub eax, 8'])
        self.counter += 1

    def stack_adder(self, element):
        """
        Add to asm code push and pop of some register.
        :param element: tuple of elements
        :return: None
        """
        index = element[1]
        self.content.insert(index + self.counter, ['push eax'])
        self.counter += 1
        self.content.insert(index + self.counter, ['pop eax'])
        self.counter += 1

    def mov_transformer(self):
        """
        Modify every mov command.
        :return: None
        """
        for i in range(len(self.mov_lst)):
            choice = random.choice([1, 2])
            if choice == 1:
                self.nope_adder(self.mov_lst[i])
            else:
                self.stack_adder(self.mov_lst[i])

    def add_sub_transformer(self):
        """
        Modify every add and sub command.
        :return: None
        """
        for i in range(len(self.add_sub_lst_im)):
            choice = random.choice([1, 2, 3])
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
        self.parser_mov()
        self.classification_add_sub()
        self.mov_transformer()
        self.add_sub_transformer()
        content = str()
        for i in range(len(self.content)):
            content += self.content[i][0]
            if i != len(self.content) - 1:
                content += '\n'
        with open("out.asm", 'w') as f:
            f.write(content)


if __name__ == "__main__":
    a = SimplePol("simple.asm")
    a.polymorph()
