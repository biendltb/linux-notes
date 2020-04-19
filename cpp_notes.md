Emerging from the academia world and arriving the industry planet as a novice, I believe the best way to learn is to putting down every simple pieces of knowledge that I collected in a place that I could adjust and modify at ease. So here it is...

### gcc/g++
CMake let you got your code compiled without bothering much about the long command in gcc. However, when you wanna make a very quick test on a sample code, using CMake is like using a shotgun to kill a fly. Knowing to write a simple gcc command is helpful in this case.
```bash
g++ test_main.cpp -I/path/to/include/dir/  -L/path/to/source/dir/ -o test_main
```

### Inheritance, virtual methods and list initialization
I used to use Java a lot and love its keywords for creating abstract class and interfaces.
C++ has less flexible design for it but we still have various way to deal with it.
```cpp
#include <iostream>
class Base {
public:
    Base(int x) : num_(x){
        std::cout << "Base class: constructor" << std::endl;
    }
    virtual void show() {
        std::cout << "Base class: Show" << std::endl;
    }
protected:
    const int num_;
    float abc;
};

class Derived : public Base {
public:
    Derived(int x) : Base(x) {
        abc = 11;
        std::cout << "Derived class: constructor" << std::endl;
    }

    void show() {
        std::cout << "Derived class: Show num_: " << num_ << std::endl;
    }

    void show_derived() {
        std::cout << "Derived class: Show for derived class only" << std::endl;
    }
    
};

int main(int argc, char *argv[]) {

    // Base* base = new Base();
    // base->show();

    Base* derived = new Derived(17);
    derived->show();
    /*
        Base class: constructor
        Derived class: constructor
        Derived class: Show num_: 17
    */
}
```


### Check if a file/dir exists | create a dir using stat
See more at: https://github.com/biendltb/linux-notes/blob/master/cpp/utils.hpp
```cpp
#include <sys/stat.h>
#include <sys/types.h>

#include <string>

namespace fs {
static bool fileExist(const std::string &path) {
    bool isExist = false;
    struct stat info;
    if (stat(path.c_str(), &info) == 0) {
        if (info.st_mode & S_IFREG) {
            isExist = true;
        }
    }

    return isExist;
}

static bool dirExist(const std::string &path) {
    bool isExist = false;
    struct stat info;
    if (stat(path.c_str(), &info) == 0) {
        if (info.st_mode & S_IFDIR) {
            isExist = true;
        }
    }

    return isExist;
}

static bool createDirectory(const std::string &path) {
    return (mkdir(path.c_str(), 0777) == 0);
}

}  // namespace fs

```


### getters/setters
More details: http://demin.ws/blog/english/2010/11/09/naming-convension-for-getters-and-setters-in-cpp/
```cpp
// Java way
class Foo {
  Value field_;
public:
  void setField(const Value& value) { field_ = value; }
  const Value& getField() const { return field_; }
};

// Usage
Foo foo;
foo.setField(field_instance);
field_instance = foo.getField();
```