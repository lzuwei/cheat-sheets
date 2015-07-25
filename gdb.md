# GDB Cheats
GNU Debugger

## Starting a session
```
gdb [name-of-executable]
gdb -e [name-of-executable] -c [name-of-core-file]
gdb [name-of-executable] --pid=process-id 
```

Example: attach to process
```
[prompt]$ ps -auxw | grep myapp
user1     2812  0.7  2.0 1009328 164768 ?      Sl   Jun07   1:18 /opt/bin/myapp
[prompt]$ gdb /opt/bin/myapp 2812
OR
[prompt]$ gdb /opt/bin/myapp --pid=2812
```

## GDB Commands

### Commandline Options

| Command | Description |
| :------------ |:---------------| 
| `--exec=filename` | Identify executable associated with core file. |
| `--core=name-of-core-file` | Specify core file. |
| `--pid=process-id` | Specify process ID number to attach to. |
| `--cd=directory` | run gdb in specific directory |
| `--directory=directory` | specify directories to find source files |
| `--args=program-args` | run gdb with program arguments |

### General Commands

| Command | Description |
| :------------ |:---------------| 
| `help`      | list gdb command topics |
| `help [topic-classes]` | list gdb commands within class |
| `apropos [search-word]` | search for commands and command topics containing search-word |
| `info [args]` or `i [args]` | list program command line arguments |
| `info breakpoints` | List breakpoints |
| `info break` | list breakpoint numbers |
| `info break [breakpoint-num]` | list info about specific breakpoint |
| `info watchpoints` | list watches |
| `info registers` | list registers in use |
| `info threads` | list threads in use |
| `info set` | list set-ables in use |

### Break and Watch

| Command | Description |
| :------------ |:---------------| 
| `break` or `b` `[func-name | line-num | ClassName::functionName]` | Suspend program at specified function of line number. |
| `break +/- [offset]` | break at +/- offset from breakpoint |
| `break [filename:function]` | break at file name and function |
| `break [filename:line-number]` | break at filename and line number |
| `break [*address]` | break at instruction address (when no source) |
| `break [line-num] if [cond]` | break at line with condition |
| `break [line] thread [thread-number]` | break at thread in line number, use info threads to get thread number |
| `watch [cond]` | break when watch meets condition |
| `clear [function] | [line-number]` | clear breakpoints in function or line number |
| `delete` or `d` | delete all breakpoints or watchpoints or catchpoints |
| `delete breakpoint-number` | delete the breakpoints, watchpoints, or catchpoints of the breakpoint ranges specified as arguments. |
| `disable` or `enable [breakpoint-num]` | disable / enable breakpoint, does not delete |
| `continue` or `c` | continue running program until next breakpoint | 
| `continue [number]` | continue but ignore breakpoints for number of times |
| `finish` | continue until end of function |

### Line Execution
| Command | Description |
| :------------ |:---------------| 
| `step` or `s`  | step to next line, will enter functions |
| `step [num-steps]` | step num-steps from current line |
| `next` | execute next line of codes, will not enter functions |
| `until [line-number]` | continue processing until line-number, breakpoint, function |
| `info signals` | show signals |
| `info handles` | show available handle options |
| `handle [SIGNAL-NAME] option` | Perform the following option when signal recieved: nostop, stop, print, noprint, pass/noignore or nopass/ignore |
| `where` | Shows current line number and which function you are in. |

### Stack Trace
| Command | Description |
| :------------ |:---------------| 
| `backtrace` or `bt` | prints stack trace |
| `backtrace full` | prints values of local variables |
| `frame` | show current frame |
| `frame [number]` | go to frame number |
| `up` or `down [number]` | move up or down x number of frames, if none specified assumes 1 |
| `info frame` | List address, language, address of arguments/local variables and which registers were saved in frame |
| `info [args|locals|catch]` | Info arguments of selected frame, local variables and exception handlers. |

### Source Code
| Command | Description |
| :------------ |:---------------| 
| `list or l [function|line-num|filename:func]` | show source code |
| `set listsize [count]` | set number of lines to show on list command |
| `directory [directory-name]` | Add specified directory to front of source code path. |
| `directory` | clear source path when nothing specified |

### Machine and Memory
| Command | Description |
| :------------ |:---------------| 
| `info line [line-num]` | Displays the start and end position in object code for the current line in source.
| `disassemble [0xstart] [0xend]` | Displays machine code for positions in object code specified (can use start and end hex memory values given by the info line command. |
| `stepi|nexti` | step or next processor instruction |
| `x 0xaddress` | Examine the contents of memory. |
| `x/nfu 0xaddress` | Examine the contents of memory and specify formatting, n = num items display, f = format, u = size of data.  eg: `x/4dw var` |

### Examine Variables
| Command | Description |
| :------------ |:---------------| 
| `print [variable-name|filename::varname]` | Print value stored in variable, "" to specify long files |
| `p *array-variable@length` | Print first # values of array specified by length. Good for pointers to dynamicaly allocated memory |
| `p/x variable` | Print as integer variable in hex. |
| `p/d variable` | Print as signed integer variable. |
| `p/u variable` | Print as unsigned integer variable. |
| `p/o variable` | Print as integer variable in oct. |
| `p/t variable` | Print as integer variable in binary. |
| `x/b address` | Print address as binary |
| `p/c variable` | Print integer as character |
| `p/f variable` | Print variable as floating point number |
| `p/a variable` | Print as Hex Address |
| `x/w address` | Print binary representation of 4 bytes (1 32 bit word) of memory pointed to by address. |
| `ptype variable` | Prints type definition of the variable or declared variable type. Helpful for viewing class or struct definitions while debugging. |

### Start Stop
| Command | Description |
| :------------ |:---------------| 
| `run [args]` | Run with arguments |
| `continue` or `c` | continue to next breakpoint |
| `kill` | Stop program execution.
| `quit` | exit |

### Dereferencing STL Containers 
| Data Type | Command |
| :------------ |:---------------| 
| std::vector<T> | `pvector [stl_variable]` |
| std::list<T> | `plist [stl_variable] T` | 
| std::string | `pstring [stl_variable]` |

Deduce from container class name eg: `std::set<T> = pset [stl_variable]` 
Where T refers to native C++ data types. While classes and other STL data types will work with the STL container classes, this de-reference tool may not handle non-native types.

## References
- [GNU Debugger Cheat Sheet](http://www.yolinux.com/TUTORIALS/GDB-Commands.html)
