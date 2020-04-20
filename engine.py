import re
import random


class SimplePol:
    def __init__(self, path):
        self.path = path
        self.counter = 0
        self.content = list()
        self.mov_lst = list()
        self.sub_lst = list()

    def reader(self):
        with open(self.path) as f:
            for line in f:
                self.content.append(line.strip().split('\n'))

    def parser_mov(self):
        for i in range(len(self.content)):
            if re.match("mov", self.content[i][0]):
                self.mov_lst.append((self.content[i][0], i))

    def parser_sub(self):
        for i in range(len(self.content)):
            if re.match("sub", self.content[i][0]):
                self.sub_lst.append((self.content[i][0], i))

    @staticmethod
    def number_division(number):
        return random.randrange(number)

    @staticmethod
    def line_maker(line, number):
        new_line = str()
        i = 0
        while line[i] != ',':
            new_line += line[i]
            i+=1
        new_line += ','
        new_line += str(number)
        return new_line

    def mov_transformer(self):
        for i in range(len(self.mov_lst)):
            index = self.mov_lst[i][1]
            self.content.insert(index + self.counter, ['nop'])
            self.counter += 1

    def sub_transformer(self):
        choice = random.choice([1,2])
        if choice == 1:
            for i in range(len(self.sub_lst)):
                index = self.sub_lst[i][1]
                self.content.insert(index + self.counter, ['nop'])
                self.counter += 1
        else:
            for i in range(len(self.sub_lst)):
                length = len(self.sub_lst[i][0])
                number = str()
                while self.sub_lst[i][0][length - 1] != ',':
                    number += self.sub_lst[i][0][length - 1]
                    length -= 1
                number = int(number[::-1])
                div = self.number_division(number)
                new_line = self.line_maker(self.sub_lst[i][0], div)
                self.content.insert(self.sub_lst[i][1] + self.counter, [new_line])
                self.counter += 1
                self.content[self.content.index([self.sub_lst[i][0]])] =\
                    [self.line_maker(self.sub_lst[i][0], number - div)]

    def polymorph(self):
        self.reader()
        self.parser_sub()
        self.parser_mov()
        self.mov_transformer()
        self.sub_transformer()
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