# Notes and tips for pybind11

### Convert C++ reference style to Python return style
C++ usually return the output via reference parameters while Python usually do it by returning values. We could change it by using a lambda function.

For example:
```cpp
class Stream {
public:
    Stream(const std::string &address);
    void recvData(std::string &data, timeout=-1);
};
```

In wrapping:
```cpp
py::class_<Stream>(m, "Stream")
    .def(py::init<const std::string &>(), "address"_a,
        "Create object with address")
    .def("recv_data",
        [](Stream &stream, int timeout) {
            std::string data;
            stream.recvData(data, timeout);
            return data;
        },
        "timeout"_a = -1,
        "Receive data with timeout");
```

### Wrap class/function that use template
* To wrap a function/method with template, we have to bind all possible types explicitly and declare like what doing with overloaded methods.

For example:
```cpp
template<typename T>
struct Vector3 {
    T x;
    T y;
    T z;
};

// Wrapping:
py::class_<ImuSet::Vector3<double>>(m, "Vector3")
    .def(py::init())
    .def_readwrite("x", &ImuSet::Vector3<double>::x)
    .def_readwrite("y", &ImuSet::Vector3<double>::y)
    .def_readwrite("z", &ImuSet::Vector3<double>::z);
```

### Declare a nested class/enum
* To declare a class/enum that is nested in another class. We need define separate object when declare the "parent" as an object before define its methods. Then pass the parent object as the module when declare the children one.

For example:
```cpp
class A {
public:
    void test();
    enum B {
        ITEM0 = 0,
        ITEM1 = 1
    };
};
```

```cpp
py::class_<A> objA(m, "A");
objA.def("test", &A::test);

py::enum_<A::B>(objA, "B")
    .value("ITEM0", A::B::ITEM0)
    .value("ITEM1", A::B::ITEM1);

```
