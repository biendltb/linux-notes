Lessons for writting good C++ code from: http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-philosophy

## Philosophy
1. Express ideas directly in code

    Writing code is like telling story. Code should be readable in the way as stories in human languages. (e.g. use meaningful names for types, varables).
    Also, try to maximize the use of the standard library to make your code clean.

2. Write in ISO Standard C++
3. Express intent
    
    Minimise the number of variables, pieces of code that you write and make sure that they have their own reason to be there.
    
    For example, good ways to make a for loop:

    ```cpp
    // read only
    for (const auto& x : v) { 
        /* do something with the value of x */ 
    }

    for (auto& x : v) { 
        /* modify x */ 
    }
    ```
4. Ideally, a program should be statically type safe
5. Prefer compile-time checking to run-time checking

    Instead of checking with code logic (run-time checking), use some compile-time check such as `static_assert`
6. 