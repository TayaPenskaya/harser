# harser

## Часть 1. Трансформеры монад и advanced types

В этом задании вам предлагается реализовать интерпретатор и prerry-printer для
подмножества вашего любимого языка программирования. В качестве любимого языка
программирования можно выбрать любой разумный императивный язык (C, Python, Go,
Pascal). Также вы можете реализовать задания для языка Prolog.

Для этого вам нужно реализовать следующее:
* Необходимо поддержать конструкции для работы с переменными (присваивание, чтение
с клавиатуры, печать на стандартный вывод).
* Типы данных: числа целые и с плавающей точкой, строки и булы.
* Конструкции условных переходов и циклов (хотя бы один из циклов for, while,
 until на выбор).
* Функции, которые принимают от 0 до 2 аргументов и возвращают в качестве
результата одно значение, например:
  ```
  def max(a, b):
      return a > b
  ```
* Парсер для грамматики языка, который будет переводить текст программы в
хаскельный eDSL.
 * Для написания парсера можно (и даже рекомендуется) использовать парсер
 библиотеки, например megaparsec, а также библиотеки с парсер-генераторами,
 например happy.
* Интерпретатор, который будет интерпретировать хаскельный eDSL.
* Принтер, который будет красиво печатать хаскельный eDSL.
* Исполняемый файл, который можно вызвать для интерпретации или pretty-printing’а
программы из текстового файла, в котором содержится код на выбранном вами языке программирования.


При выполнении задания обратите внимание на обработку ошибок, интерпретатор
должен падать с человекочитаемыми ошибками. При выполнении настоятельно
рекомендуется использовать free-monad'ы или tagless final.

## Helpful links

[precedence](https://rosettacode.org/wiki/Operator_precedence#Haskell)
[final tagless](https://slides.com/fp-ctd/lecture-11#/18/0/2)
