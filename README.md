# Share

[![](https://img.shields.io/badge/Swift-4.2-orange.svg)][1]
[![](https://img.shields.io/badge/os-macOS%20|%20Linux-lightgray.svg)][1]
[![](https://travis-ci.com/DavidSkrundz/Share.svg?branch=master)][2]
[![](https://codebeat.co/badges/3a65d86f-2c2e-4c74-ac69-831d95e34b90)][3]
[![](https://codecov.io/gh/DavidSkrundz/Share/branch/master/graph/badge.svg)][4]

[1]: https://swift.org/download/#releases
[2]: https://travis-ci.com/DavidSkrundz/Share
[3]: https://codebeat.co/projects/github-com-davidskrundz-share-master
[4]: https://codecov.io/gh/DavidSkrundz/Share

Shamir's Secret Sharing

## CLI

The cli provides an example of using `Share` with multiple types and multiple values

##### Example

```Bash
$ echo Some text to split > input.txt
$ swift run Share split -c 3 -n 2 -s 0 -i input.txt -o share.%.txt
$ swift run Share merge -o output.txt share.2.txt share.1.txt
$ xxd input.txt
00000000: 536f 6d65 2074 6578 7420 746f 2073 706c  Some text to spl
00000010: 6974 0a                                  it.
$ xxd output.txt
00000000: 536f 6d65 2074 6578 7420 746f 2073 706c  Some text to spl
00000010: 6974 0a00 00                             it...
```

##### Split

```
$ swift run Share split
Missing count

OPTIONS:
  --count, -c <value>     Number of parts to create
  --needed, -n <value>    Number of parts needed
  --security, -s <value>  The security level (0,1,2,3,4,5,9)
  --input, -i <value>     Input file
  --output, -o <value>    Output file pattern (A%B.txt -> A1B.txt, A2B.txt)
  --help, -h 
```

##### Merge

```
$ swift run Share merge
Usage: Share merge <options> <input...>

OPTIONS:
  --output, -o <value>    Output file
```

## Importing

```Swift
.package(url: "https://github.com/DavidSkrundz/Share.git", .upToNextMinor(from: "1.0.0"))
```

## `Share<T: FiniteFieldInteger>`

Provides `split` and `join` to either create a list of shares into a value, or combine a list of shares into a value:

```Swift
static func split(value: T, count: Int, needed: Int) -> [Share]
static func join<S: RandomAccessCollection>(shares: S) -> T where S.Element == Share, S.Index == Int
```
