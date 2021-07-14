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
In C++, if getters/setters are used for objects (e.g., `std::string`) rather than original type (`int`, `char`), it's better to set it as a reference instead of copy. Also, `const` should be used to avoid the change of return value.
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

### stringstream or print text format
For print number with fixed width by filling '0' in

```cpp
#include <iostream>
#include <iomanip>

# Note: std::fixed to keep the format along the current session
# fill for int value where zeros could be fill in left side
#define FORMAT_SET(x) std::setprecision(x) << std::right << std::setw(x) << std::setfill('0') << std::fixed

# for floating point where zeros is fill on the decimal part
#define FORMAT_SET(x) std::setprecision(x) << std::showpoint << std::fixed

std::stringstream ss;
ss << FORMAT_SET(9)
    << position.x() << " " << position.y() << " " << position.z() << " "
    << FORMAT_SET(15)
    << orientation.x() << " " << orientation.y() << " " << orientation.z() << " " << orientation.w() << "\n";
    
std::cout << ss.str();
```

### Use smart pointers and avoid raw pointers in C++
It's a good practice to use smart pointers in C++. Use `std::unique_ptr` for local pointers and `std::shared_ptr` for references and shareable pointers.

```cpp
// e.g. create a pointer for array of char with a specific size
std::unique_ptr<char[]> buff = std::make_unique<char[]>(1024);
```

### Mutex and mutex wrappers
Mutex is used to control the access of multiple threads to a shared resource.

Controlling mutex by `lock()` and `unlock()` could be complicated. Errors could easily occur if the mutex is not released properly. The purposes of lock wrappers is to bind the lock/release of a mutex to the initialize/destruction of a lock wrapper (similar to the concept of smart pointers), which is a RAII-style mechanism. This mechanism is similar to smart pointers to avoid forgetting to unlock the mutex after finish the operation which could potentially caused the deadlock.

Some mutex wrappers:
* `lock_guard`: is the most simple form mutex wrapper, it takes ownership of mutex when being created and release the mutex when being destructed.
* `unique_lock`: is more flexible than `lock_guard`. It won't lock immedately after created and could be unlock at any point of a function.
* `scoped_lock`: introduces in C++ 17 to replace the `lock_guard` with more advance features such as holding multiple mutexes at the same time.

### Conditional variable
Mutex could be useful when two or more threads wait for each other to access or modify a shared resource. In many cases, one thread must wait for another thread to finish its task before the waiting thread could perfom its work.

Take a simple example, one thread receives and process an image, another thread will save the processed image.

Without using a conditional variable, the saving thread will have to always pool to check if the image is processed:
```cpp
Image im;
bool is_processed = false;
std::mutex mtx;

void im_proc()
{
    std::lock_guard<std::mutex> lock(mtx);
    // processing the image
    is_processed = true;
}

void im_saving()
{
    while (true)
    {
        std::lock_guard<std::mutex> lock(mtx);
        if (is_processed)
        {
            // save the image and exit the thread
            break;
        }
     }
}

int main()
{
    std::thread t0(im_proc), t1(im_saving);
    t0.join();
    t1.join();
    return 0;
}
```

With conditional variable, the `std::conditional_variable` will do the job of handling the mutex and wait for you:
```cpp
Image im;
std::conditional_variable cv;
std::mutex mtx;

void im_proc()
{
    std::lock_guard<std::mutex> lock(mtx);
    // processing the image
    cv.notify_one();
}

void im_saving()
{
    std::unique_lock<std::mutex> lock(mtx);
    cv.wait(lock);
    // save the image and exit the thread
}

int main()
{
    std::thread t0(im_proc), t1(im_saving);
    t0.join();
    t1.join();
    return 0;
}
```
Check the example in the cppreference page to see how a main thread and a worker thread work in sequentials parts of the pipeline using conditional variable: https://en.cppreference.com/w/cpp/thread/condition_variable

### thread
Quick notes:
* Use `std::shared_ptr` for objects shared between threads
* Avoid passing local variables to a lambda function as refereces since they no longer exist by the time the lambda function is called. Consider the copy.
    ```cpp
    // reference to local --> bad
    thread_pool.queue_work([&] { process(local); });
    // copy --> good
    thread_pool.queue_work([=] { process(local); });
    ```
* Use `std::ref` when passing object as to a function with reference arguments (see example below)

    e.g. Passing a method of an object to a thread:
    ```cpp
    void ClassA::test(ClassB &objB, bool c) {
        // do something
    }

    void classA::testTh() {
        std::thread t0(&ABC::test, this, std::ref(objX), y);
    }
    ```
### Loop through a `std::vector` or a `std::set` using iterator
When browse through a vector or set, we could use `std::advance` or `std::next` if we want to access the list arbitrarily, not follow any linear direction. Both `std::advance` and `std::next` allow us to increase/decrease an iterator but `std::next` get a copy, apply the change and return a value while `std::advance` does not return anything.

e.g.:
```cpp
std::set<int> a = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
std::set<int>::iterator it = a.begin();

while (true) {
    std::cout << *it << std::endl;
    std::advance(it, 1);
    // reach the end
    // Note: std::next will not increase it if it's not assigned
    if (std::next(it) == a.end())
        break;
}
```


## Fundamental tips:
* Always pass objects as references in method parameters to save copy/memory. (Note: instances of `std::string` are objects).
* An elegant for loop over an vector could be:
    ```cpp
    for (auto& x: v)
    {
        ...
    }
    ```
