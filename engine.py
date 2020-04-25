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
        self.sub_lst = list()
        self.add_lst = list()

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

    def parser_sub(self):
        """
        Find all sub commands in asm file.
        :return: None
        """
        self.parser("sub", self.sub_lst)

    def parser_add(self):
        """
        Find all add commands in asm file.
        :return: None
        """
        self.parser("add", self.add_lst)

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
            i+=1
        new_line += ','
        new_line += str(number)
        return new_line

    def nope_adder(self, lst):
        """
        Add to asm code nop.
        :param lst: list of strings
        :return: None
        """
        for i in range(len(lst)):
            index = lst[i][1]
            self.content.insert(index + self.counter, ['nop'])
            self.counter += 1

    def division_adder(self, lst):
        """
        Add to asm code divided command of add or sub like:
        add eax 5
        add eax 3
        Instead of add eax 8
        :param lst: list of strings
        :return: None
        """
        for i in range(len(lst)):
            length = len(lst[i][0])
            number = str()
            while lst[i][0][length - 1] != ',':
                number += lst[i][0][length - 1]
                length -= 1
            number = int(number[::-1])
            div = self.number_division(number)
            new_line = self.line_maker(lst[i][0], div)
            self.content.insert(lst[i][1] + self.counter, [new_line])
            self.counter += 1
            self.content[self.content.index([lst[i][0]])] = \
                [self.line_maker(lst[i][0], number - div)]

    def stack_adder(self, lst):
        """
        Add to asm code push and pop of some register.
        :param lst: list of strings
        :return: None
        """
        for i in range(len(lst)):
            index = lst[i][1]
            self.content.insert(index + self.counter, ['push eax'])
            self.counter += 1
            self.content.insert(index + self.counter, ['pop eax'])
            self.counter += 1

    def mov_transformer(self):
        """
        Modify every mov command.
        :return: None
        """
        choice = random.choice([1, 2])
        if choice == 1:
            self.nope_adder(self.mov_lst)
        else:
            self.stack_adder(self.mov_lst)

    def sub_transformer(self):
        """
        Modify every sub command.
        :return: None
        """
        choice = random.choice([1, 2, 3])
        if choice == 1:
            self.nope_adder(self.sub_lst)
        elif choice == 2:
            self.stack_adder(self.sub_lst)
        else:
            self.division_adder(self.sub_lst)

    def add_transformer(self):
        """
        Modify every add command.
        :return: None
        """
        choice = random.choice([1, 2, 3])
        if choice == 1:
            self.nope_adder(self.add_lst)
        elif choice == 2:
            self.stack_adder(self.add_lst)
        else:
            self.division_adder(self.add_lst)

    def polymorph(self):
        """
        Make code polymorphous and write it to new asm file.
        :return:  None
        """
        self.reader()
        self.parser_sub()
        self.parser_mov()
        self.parser_add()
        self.mov_transformer()
        self.sub_transformer()
        self.add_transformer()
        content = str()
        for i in range(len(self.content)):
            content += self.content[i][0]
            if i != len(self.content) - 1:
                content += '\n'
        with open("out.asm", 'w') as f:
            f.write(content)


if __name__ == "__main__":
    a = SimplePol("asm/bubble_sort.asm")
    a.polymorph()
