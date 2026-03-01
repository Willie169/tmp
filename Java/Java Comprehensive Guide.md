# Java Comprehensive Guide

## Table of Contents
1. [Introduction to Java](#1-introduction-to-java)
2. [Basic Syntax](#2-basic-syntax)
3. [Data Types](#3-data-types)
4. [Operators](#4-operators)
5. [Type Casting](#5-type-casting)
6. [Classes and Objects](#6-classes-and-objects)
7. [Interfaces and Abstract Classes](#7-interfaces-and-abstract-classes)
8. [Generics](#8-generics)
9. [Annotations](#9-annotations)
10. [Exception Handling](#10-exception-handling)
11. [Synchronization](#11-synchronization)
12. [Reflection](#12-reflection)
13. [Records](#13-records)
14. [Java Modules](#14-java-modules)
15. [Best Practices and Conventions](#15-best-practices-and-conventions)

## 1. **Introduction to Java**

Java is a high-level, class-based, object-oriented programming language designed to have as few implementation dependencies as possible. It follows the principle of "Write Once, Run Anywhere" (WORA), meaning that code written in Java can run on any platform that has a Java Virtual Machine (JVM).

## 2. **Basic Syntax**

### **Hello World Example**
```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

### **Java File Structure**
- Each Java file should have one public class with the same name as the file.
- The `main` method, which serves as the entry point of a Java application, should be `public static void main(String[] args)`.

## 3. **Data Types**
### **Primitive Data Types**
- **`byte`**: 8-bit signed integer. Range: -128 to 127. 
- **`short`**: 16-bit signed integer. Range: -32,768 to 32,767. 
- **`int`**: 32-bit signed integer. Range: -2^31 to 2^31 - 1. 
- **`long`**: 64-bit signed integer. Range: -2^63 to 2^63 - 1. 
- **`float`**: 32-bit floating-point number. Precision: 6-7 decimal digits.
- **`double`**: 64-bit floating-point number. Precision: 15-16 decimal digits.
- **`char`**: 16-bit Unicode character. Range: '\u0000' to '\uffff'.
- **`boolean`**: Represents true or false values.

### **Library Types**

<ul>
  <li>
    <p><strong>Wrapper Classes</strong>: <strong><code>Byte</code></strong>, <strong><code>Short</code></strong>, 
      <strong><code>Integer</code></strong>, <strong><code>Long</code></strong>, <strong><code>Float</code></strong>, 
      <strong><code>Double</code></strong>, <strong><code>Character</code></strong>, and <strong><code>Boolean</code></strong> 
      are Wrapper classes that provide an object representation for the eight primitive data types, allowing them to be used as objects when necessary. 
      Each primitive data type has a corresponding wrapper class, and these wrapper classes are part of the 
      <code>java.lang</code> package. Wrapper class objects are immutable.
    </p>
    <ul>
      <li>The primitive types and their corresponding wrapper classes:
        <table>
          <thead>
            <tr>
              <th>Primitive Type</th>
              <th>Wrapper Class</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><code>byte</code></td>
              <td><code>Byte</code></td>
            </tr>
            <tr>
              <td><code>short</code></td>
              <td><code>Short</code></td>
            </tr>
            <tr>
              <td><code>int</code></td>
              <td><code>Integer</code></td>
            </tr>
            <tr>
              <td><code>long</code></td>
              <td><code>Long</code></td>
            </tr>
            <tr>
              <td><code>float</code></td>
              <td><code>Float</code></td>
            </tr>
            <tr>
              <td><code>double</code></td>
              <td><code>Double</code></td>
            </tr>
            <tr>
              <td><code>char</code></td>
              <td><code>Character</code></td>
            </tr>
            <tr>
              <td><code>boolean</code></td>
              <td><code>Boolean</code></td>
            </tr>
          </tbody>
        </table>
      </li>
      <li><strong>Use in Collections</strong>: Java collections like <code>ArrayList</code> can only hold objects, not primitive types. Wrapper classes allow you to store primitive values in collections.
        <pre><code class="lang-java">ArrayList&lt;Integer&gt; numbers = new ArrayList&lt;&gt;();
numbers.add(10);  // Autoboxing of int to Integer
        </code></pre>
      </li>
      <li><strong>Autoboxing and Unboxing</strong>: Java automatically converts between primitive types and their corresponding wrapper classes. This is called <strong>autoboxing</strong> (primitive to wrapper) and <strong>unboxing</strong> (wrapper to primitive). For example:
        <pre><code class="lang-java">int primitive = 10;
Integer wrapper = primitive;  // Autoboxing
int newPrimitive = wrapper;  // Unboxing
        </code></pre>
      </li>
      <li><strong>Object Methods</strong>: Primitive types do not have methods, but wrapper classes provide methods for performing operations such as comparison, conversion, etc.
        <ul>
          <li><strong>Byte</strong>:
            <ul>
              <li><code>parseByte(String s)</code>: Converts a string to a byte.</li>
              <li><code>toString(byte b)</code>: Converts a byte to a string.</li>
              <li><code>compareTo(Byte b)</code>: Compares two Byte objects.</li>
            </ul>
            <pre><code class="lang-java">byte b = Byte.parseByte("12");
String str = Byte.toString(b);
int comparison = Byte.valueOf(b).compareTo((byte) 10);
            </code></pre>
          </li>
          <li><strong>Short</strong>:
            <ul>
              <li><code>parseShort(String s)</code>: Converts a string to a short.</li>
              <li><code>toString(short s)</code>: Converts a short to a string.</li>
              <li><code>compareTo(Short s)</code>: Compares two Short objects.</li>
            </ul>
            <pre><code class="lang-java">short s = Short.parseShort("123");
String str = Short.toString(s);
int comparison = Short.valueOf(s).compareTo((short) 100);
            </code></pre>
          </li>
          <li><strong>Integer</strong>:
            <ul>
              <li><code>parseInt(String s)</code>: Converts a string to an integer.</li>
              <li><code>toString(int i)</code>: Converts an integer to a string.</li>
              <li><code>compareTo(Integer i)</code>: Compares two Integer objects.</li>
            </ul>
            <pre><code class="lang-java">int num = Integer.parseInt("123");
String str = Integer.toString(num);
int comparison = Integer.valueOf(num).compareTo(100);
            </code></pre>
          </li>
          <li><strong>Long</strong>:
            <ul>
              <li><code>parseLong(String s)</code>: Converts a string to a long.</li>
              <li><code>toString(long l)</code>: Converts a long to a string.</li>
              <li><code>compareTo(Long l)</code>: Compares two Long objects.</li>
            </ul>
            <pre><code class="lang-java">long l = Long.parseLong("123456789");
String str = Long.toString(l);
int comparison = Long.valueOf(l).compareTo(100000L);
            </code></pre>
          </li>
          <li><strong>Float</strong>:
            <ul>
              <li><code>parseFloat(String s)</code>: Converts a string to a float.</li>
              <li><code>toString(float f)</code>: Converts a float to a string.</li>
              <li><code>compareTo(Float f)</code>: Compares two Float objects.</li>
            </ul>
            <pre><code class="lang-java">float f = Float.parseFloat("3.14");
String str = Float.toString(f);
int comparison = Float.valueOf(f).compareTo(2.71f);
            </code></pre>
          </li>
          <li><strong>Double</strong>:
            <ul>
              <li><code>parseDouble(String s)</code>: Converts a string to a double.</li>
              <li><code>toString(double d)</code>: Converts a double to a string.</li>
              <li><code>compareTo(Double d)</code>: Compares two Double objects.</li>
            </ul>
            <pre><code class="lang-java">double d = Double.parseDouble("3.14159");
String str = Double.toString(d);
int comparison = Double.valueOf(d).compareTo(2.71828);
            </code></pre>
          </li>
          <li><strong>Character</strong>:
            <ul>
              <li><code>isDigit(char ch)</code>: Checks if the character is a digit.</li>
              <li><code>isLetter(char ch)</code>: Checks if the character is a letter.</li>
              <li><code>toUpperCase(char ch)</code>: Converts a character to uppercase.</li>
              <li><code>toLowerCase(char ch)</code>: Converts a character to lowercase.</li>
            </ul>
            <pre><code class="lang-java">char ch = 'a';
boolean isDigit = Character.isDigit(ch);
boolean isLetter = Character.isLetter(ch);
char upper = Character.toUpperCase(ch);
char lower = Character.toLowerCase('B');
            </code></pre>
          </li>
          <li><strong>Boolean</strong>:
            <ul>
              <li><code>parseBoolean(String s)</code>: Converts a string to a boolean.</li>
              <li><code>toString(boolean b)</code>: Converts a boolean to a string.</li>
              <li><code>compareTo(Boolean b)</code>: Compares two Boolean objects.</li>
            </ul>
            <pre><code class="lang-java">boolean bool = Boolean.parseBoolean("true");
String str = Boolean.toString(bool);
int comparison = Boolean.valueOf(bool).compareTo(false);
            </code></pre>
          </li>
        </ul>
      </li>
    </ul>
  </li>
</ul>

- **Container Classes**:
  - **BigInteger**: For handling arbitrarily large integers.
    - **BigInteger** provides methods for arithmetic, modular arithmetic, bit manipulation, and prime number generation.
    - Static methods:
      - `add(BigInteger val)`: Adds two BigInteger values.
      - `subtract(BigInteger val)`: Subtracts one BigInteger value from another.
    ```java
    BigInteger bigInt1 = new BigInteger("12345678901234567890");
    BigInteger bigInt2 = new BigInteger("98765432109876543210");
    BigInteger sum = bigInt1.add(bigInt2);
    System.out.println(sum); // Output: 111111111011111111100
    ```
  
  - **BigDecimal**: For handling arbitrary-precision decimal numbers.
    - **BigDecimal** is used for high-precision arithmetic operations on floating-point numbers.
    - Static methods:
      - `add(BigDecimal val)`: Adds two BigDecimal values.
      - `divide(BigDecimal val)`: Divides this BigDecimal by another BigDecimal.
    ```java
    BigDecimal bd1 = new BigDecimal("12345.6789");
    BigDecimal bd2 = new BigDecimal("9876.54321");
    BigDecimal result = bd1.add(bd2);
    System.out.println(result); // Output: 22222.22211
    ```
  
  - **String**: Immutable sequence of characters.
    - **String** class in Java is used to create and manipulate strings.
    - Strings are immutable, meaning once created, their values cannot be changed. Operations on strings result in the creation of new string objects.
    - Static methods:
      - `length()`: Returns the length of the string.
      - `substring(int start, int end)`: Extracts a substring from the string.
      - `toUpperCase()`: Converts all characters in the string to uppercase.
      - `toLowerCase()`: Converts all characters in the string to lowercase.
      - `charAt(int index)`: Returns the character at the specified index.
    ```java
    String str = "Hello, World!";
    System.out.println(str.length()); // Output: 13
    System.out.println(str.substring(7, 12)); // Output: World
    System.out.println(str.toUpperCase()); // Output: HELLO, WORLD!
    ```
  
  - **`StringBuilder`**: A mutable sequence of characters. It is used for creating and manipulating strings.
    ```java
    StringBuilder sb = new StringBuilder();
    sb.append("Hello");
    sb.append(" World");
    System.out.println(sb.toString()); // Output: Hello World
    ```
  
  - **`StringBuffer`**: Similar to `StringBuilder` but is synchronized, making it thread-safe.
    ```java
    StringBuffer sb = new StringBuffer();
    sb.append("Hello");
    sb.append(" World");
    System.out.println(sb.toString()); // Output: Hello World
    ```
  
  - **`Optional`**: A container object which may or may not contain a non-null value. Used to avoid null checks.
    ```java
    Optional<String> optional = Optional.of("Hello");
    optional.ifPresent(System.out::println); // Output: Hello
    ```
  
  - **`ArrayList`**: A resizable array implementation of the `List` interface. It allows for fast random access and dynamic resizing.
    ```java
    ArrayList<String> list = new ArrayList<>();
    list.add("Apple");
    list.add("Banana");
    ```
    
  - **`LinkedList`**: Implements both the `List` and `Deque` interfaces. It is a doubly-linked list that allows for fast insertions and deletions.
    ```java
    LinkedList<String> linkedList = new LinkedList<>();
    linkedList.add("Apple");
    linkedList.add("Banana");
    ```

  - **`PriorityQueue`**: An implementation of the `Queue` interface that orders its elements according to their natural ordering or by a specified comparator. Elements with higher priority are dequeued before elements with lower priority. It does not allow `null` elements and does not guarantee the order of elements with the same priority. `PriorityQueue` is useful when you need to process elements based on priority, such as in scheduling tasks or implementing Dijkstra’s algorithm.
  ```java
  PriorityQueue<String> priorityQueue = new PriorityQueue<>();
  priorityQueue.add("Banana");
  priorityQueue.add("Apple");
  priorityQueue.add("Cherry");
  
  while (!priorityQueue.isEmpty()) {
      System.out.println(priorityQueue.poll());
  }
  // Output (natural ordering of strings):
  // Apple
  // Banana
  // Cherry
  ```

  - **`ArrayDeque`**: A resizable array implementation of the `Deque` (double-ended queue) interface. It allows elements to be added or removed from both ends of the queue efficiently. It is faster than `LinkedList` for these operations due to its array-based structure.
    ```java
    ArrayDeque<String> deque = new ArrayDeque<>();
    deque.addFirst("Apple"); // Adds to the front of the deque
    deque.addLast("Banana"); // Adds to the end of the deque
    System.out.println(deque.removeFirst()); // Output: Apple
    System.out.println(deque.removeLast());  // Output: Banana
    ```

  - **`HashSet`**: A collection that does not allow duplicate elements and does not guarantee any order of its elements.
    ```java
    Set<String> set = new HashSet<>();
    set.add("Apple");
    set.add("Banana");
    ```
  
  - **`TreeSet`**: A `NavigableSet` implementation that uses a Red-Black tree to store elements in a sorted order.
    ```java
    Set<String> treeSet = new TreeSet<>();
    treeSet.add("Banana");
    treeSet.add("Apple");
    ```
  
  - **`LinkedHashSet`**: A hash table and linked list implementation of the `Set` interface that maintains insertion order. Unlike `HashSet`, it guarantees that elements are iterated in the order they were added.
    ```java
    Set<String> linkedHashSet = new LinkedHashSet<>();
    linkedHashSet.add("Apple");
    linkedHashSet.add("Banana");
    linkedHashSet.add("Cherry");
    
    for (String fruit : linkedHashSet) {
        System.out.println(fruit);
    }
    // Output:
    // Apple
    // Banana
    // Cherry
    ```
  
  - **`HashMap`**: A hash table based implementation of the `Map` interface. It allows for efficient key-value pair operations.
    ```java
    Map<String, Integer> map = new HashMap<>();
    map.put("One", 1);
    map.put("Two", 2);
    ```
  
  - **`TreeMap`**: A `NavigableMap` implementation that uses a Red-Black tree to store key-value pairs in a sorted order by keys.
    ```java
    Map<String, Integer> treeMap = new TreeMap<>();
    treeMap.put("One", 1);
    treeMap.put("Two", 2);
    ```
  
  - **`LinkedHashMap`**: A hash table and linked list implementation of the `Map` interface with predictable iteration order.
    ```java
    Map<String, Integer> linkedHashMap = new LinkedHashMap<>();
    linkedHashMap.put("One", 1);
    linkedHashMap.put("Two", 2);
    ```
  
  - **`Files`**: Provides static methods for file operations, such as reading, writing, and manipulating files.
    ```java
    Path path = Paths.get("example.txt");
    String content = Files.readString(path);
    System.out.println(content);
    ```
  
  - **`Paths`**: Provides static methods to obtain `Path` instances, used for file system operations.
    ```java
    Path path = Paths.get("example.txt");
    System.out.println(path.getFileName());
    ```
  
  - **`PrintWriter`**: A convenience class for writing formatted text to files or other output streams.
    ```java
    PrintWriter writer = new PrintWriter("example.txt");
    writer.println("Hello, World!");
    writer.close();
    ```
  
  - **`BufferedReader`**: Reads text from a character-based input stream, buffering characters to provide efficient reading.
    ```java
    BufferedReader reader = new BufferedReader(new FileReader("example.txt"));
    String line = reader.readLine();
    System.out.println(line);
    reader.close();
    ```
  
  - **`BufferedWriter`**: Writes text to a character-based output stream, buffering characters for efficient writing.
    ```java
    BufferedWriter writer = new BufferedWriter(new FileWriter("example.txt"));
    writer.write("Hello, World!");
    writer.close();
    ```
  
  - **`Scanner`**: A utility class for parsing and reading input from various sources like strings, files, or streams.
    ```java
    Scanner scanner = new Scanner("Hello World");
    String word = scanner.next();
    System.out.println(word); // Output: Hello
    scanner.close();
    ```
  
  - **`ExecutorService`**: Manages and controls a pool of threads for asynchronous task execution.
    ```java
    ExecutorService executor = Executors.newFixedThreadPool(2);
    executor.submit(() -> System.out.println("Task executed"));
    executor.shutdown();
    ```
  
  - **`Future`**: Represents the result of an asynchronous computation.
    ```java
    ExecutorService executor = Executors.newFixedThreadPool(1);
    Future<Integer> future = executor.submit(() -> 1 + 1);
    System.out.println(future.get()); // Output: 2
    executor.shutdown();
    ```
  
  - **`CountDownLatch`**: A synchronization aid that allows one or more threads to wait until a set of operations in other threads completes.
    ```java
    CountDownLatch latch = new CountDownLatch(1);
    new Thread(() -> {
        System.out.println("Thread started");
        latch.countDown();
    }).start();
    latch.await();
    System.out.println("Thread completed");
    ```
  
  - **`Semaphore`**: Controls access to a shared resource through counting permits.
    ```java
    Semaphore semaphore = new Semaphore(1);
    semaphore.acquire();
    System.out.println("Resource acquired");
    semaphore.release();
    ```
  
  - **`AtomicInteger`**: Provides an integer value that may be updated atomically.
    ```java
    AtomicInteger atomicInt = new AtomicInteger(0);
    atomicInt.incrementAndGet();
    System.out.println(atomicInt.get()); // Output: 1
    ```
  
  - **`ThreadLocal`**: Provides thread-local variables, where each thread has its own, independently initialized copy of the variable.
    ```java
    ThreadLocal<String> threadLocal = ThreadLocal.withInitial(() -> "Initial");
    System.out.println(threadLocal.get()); // Output: Initial
    ```
  
  - **`UUID`**: Represents a universally unique identifier (UUID).
    ```java
    UUID uuid = UUID.randomUUID();
    System.out.println(uuid.toString());
    ```
  
  - **`Date`**: Represents a specific instant in time, with millisecond precision.
    ```java
    Date date = new Date();
    System.out.println(date.toString());
    ```
  
  - **`SimpleDateFormat`**: A concrete class for formatting and parsing dates in a locale-sensitive manner.
    ```java
    SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
    String dateString = formatter.format(new Date());
    System.out.println(dateString);
    ```
  
  - **`Calendar`**: An abstract class that provides methods for manipulating dates and times.
    ```java
    Calendar calendar = Calendar.getInstance();
    calendar.set(2024, Calendar.SEPTEMBER, 18);
    System.out.println(calendar.getTime());
    ```
  
  - **`TimeZone`**: Represents a time zone offset, and also figures out daylight saving time.
    ```java
    TimeZone timeZone = TimeZone.getTimeZone("GMT");
    System.out.println(timeZone.getID());
    ```
  
  - **`LocalDate`, `LocalTime`, `LocalDateTime`**: Part of the `java.time` package for handling date and time without time zones.
    ```java
    LocalDate date = LocalDate.now();
    LocalTime time = LocalTime.now();
    LocalDateTime dateTime = LocalDateTime.now();
    System.out.println(date);
    System.out.println(time);
    System.out.println(dateTime);
    ```
  
  - **`DateTimeFormatter`**: Provides a way to format and parse dates and times.
    ```java
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    LocalDate date = LocalDate.now();
    String formattedDate = date.format(formatter);
    System.out.println(formattedDate);
    ```
  
  - **`Calendar`**: An abstract class that provides methods for manipulating dates and times.
    ```java
    Calendar calendar = Calendar.getInstance();
    calendar.set(2024, Calendar.SEPTEMBER, 18);
    System.out.println(calendar.getTime());
    ```

- **Collections Framework**: Collections Framework is unified architecture for representing and manipulating collections, allowing for efficient data manipulation.
  - **`Collection`**: The root interface of the collection hierarchy. It includes common operations like `add`, `remove`, and `size`.
  
  - **`List`**: An ordered collection (also known as a sequence) that may contain duplicate elements. Elements can be accessed by their integer index (position in the list). The common implementation for `List` are `ArrayList` and `LinkedList`.
  
  - **`Set`**: A collection that does not allow duplicate elements. The common implementation for `Set` are `HashSet`, `TreeSet`, and `LinkedHashSet`.
  
  - **`Map`**: An object that maps keys to values. It cannot contain duplicate keys, and each key can map to at most one value. The common implementation for `Map` are `HashMap`, `TreeMap`, and `LinkedHashMap`.
  
  - **`Queue`**: A collection used to hold multiple elements prior to processing. It typically orders elements in a FIFO (First In First Out) manner. The common implementation for `Queue` are `LinkedList` and `PriorityQueue`.
  
  - **`Deque`**: A double-ended queue that allows for the insertion and removal of elements from both ends. The common implementation for `Queue` are `LinkedList` and `ArrayDeque`.

## 4. **Operators**

### **Arithmetic Operators**
- **`+`**: Addition
- **`-`**: Subtraction
- **`*`**: Multiplication
- **`/`**: Division
- **`%`**: Modulus (remainder)

### **Relational Operators**
- **`==`**: Equal to\
  For Primitive Types: It compares the actual values, like `==` in Python. For example:
  ```
  int a = 5;
  int b = 5;
  boolean result = (a == b);  // result is true
  ```
  For Reference Types: It compares the memory addresses of the objects, meaning it checks whether both references point to the same object in memory, like `is` in Python. For example:
  ```
  String s1 = new String("hello");
  String s2 = new String("hello");
  boolean result = (s1 == s2);  // result is false, because s1 and s2 refer to different objects
  ```
  To compare the actual content of objects, especially for classes like String, you should use the `.equals()` method:
  ```
  boolean result = s1.equals(s2);  // result is true, because the content of s1 and s2 is the same
  ```
- **`!=`**: Not equal to
- **`<`**: Less than
- **`>`**: Greater than
- **`<=`**: Less than or equal to
- **`>=`**: Greater than or equal to

### **Logical Operators**
- **`&&`**: Logical AND
- **`||`**: Logical OR
- **`!`**: Logical NOT

### **Bitwise Operators**
- **`&`**: Bitwise AND
- **`|`**: Bitwise OR
- **`^`**: Bitwise XOR
- **`~`**: Bitwise NOT
- **`<<`**: Left shift
- **`>>`**: Right shift\
  It shifts bits to the right and preserves the sign of the original number, just like `>>` in C++. For positive numbers, it behaves like an arithmetic shift, filling the leftmost bits with zeroes. For negative numbers, it maintains the sign by filling the leftmost bits with ones (i.e., it performs an arithmetic shift).
  ```
  int x = -8;  // In binary: 11111111 11111111 11111111 11111000
  int result = x >> 2;  // Result: 11111111 11111111 11111111 11111110 (-2)
  ```
- **`>>>`**: Unsigned right shift\
  It shifts bits to the right and fills the leftmost bits with zeroes, regardless of the original number's sign. It's used for shifting without considering the sign of the number, which is particularly useful for unsigned integers.
  ```
  int x = -8;  // In binary: 11111111 11111111 11111111 11111000
  int result = x >>> 2;  // Result: 00111111 11111111 11111111 11111110 (1073741822)
  ```

### **Assignment Operators**
- **`=`**: Assignment
- **`+=`**: Addition assignment
- **`-=`**: Subtraction assignment
- **`*=`**: Multiplication assignment
- **`/=`**: Division assignment
- **`%=`**: Modulus assignment

## 5. **Type Casting**
- **Implicit Casting**: Automatically done by Java when converting from a smaller to a larger data type.
  ```java
  int i = 10;
  double d = i; // Implicit casting
  ```
- **Explicit Casting**: Required when converting from a larger to a smaller data type.
  ```java
  double d = 10.5;
  int i = (int) d; // Explicit casting
  ```

## 6. **Classes and Objects**

### **Class Definition**
```java
public class MyClass {
    // Fields
    int field;

    // Constructor
    public MyClass(int field) {
        this.field = field;
    }

    // Methods
    public void display() {
        System.out.println("Field: " + field);
    }
}
```

### **Creating Objects**
```java
MyClass obj = new MyClass(10);
obj.display();
```

### **Inheritance and `super()`**
- **Inheritance**: Allows a class to inherit fields and methods from another class.
- **`super()`**: Calls the constructor of the parent class.
  ```java
  public class Parent {
      public Parent() {
          System.out.println("Parent Constructor");
      }
  }

  public class Child extends Parent {
      public Child() {
          super(); // Calls Parent constructor
          System.out.println("Child Constructor");
      }
  }

  Child child = new Child();
  // Output:
  // Parent Constructor
  // Child Constructor
  ```

## 7. **Interfaces and Abstract Classes**

### **Interfaces**
- **Definition**: An interface in Java is a reference type that can contain only constants, method signatures, default methods, static methods, and nested types. Interfaces cannot contain instance fields or constructors.
- **Implementation**: Classes implement interfaces and provide the concrete behavior of the abstract methods declared in the interface.
- **Example**:
  ```java
  public interface Animal {
      void makeSound(); // Abstract method
  }

  public class Dog implements Animal {
      @Override
      public void makeSound() {
          System.out.println("Woof");
      }
  }

  public class Cat implements Animal {
      @Override
      public void makeSound() {
          System.out.println("Meow");
      }
  }

  public class Test {
      public static void main(String[] args) {
          Animal dog = new Dog();
          Animal cat = new Cat();
          dog.makeSound(); // Output: Woof
          cat.makeSound(); // Output: Meow
      }
  }
  ```

### **Abstract Classes**
- **Definition**: An abstract class in Java is a class that cannot be instantiated on its own and may contain abstract methods (methods without implementations) as well as concrete methods (methods with implementations).
- **Usage**: Abstract classes are used as base classes for other classes to extend and provide specific implementations.
- **Example**:
  ```java
  public abstract class Animal {
      // Abstract method (does not have a body)
      abstract void makeSound();

      // Regular method
      public void sleep() {
          System.out.println("Zzz");
      }
  }

  public class Dog extends Animal {
      @Override
      void makeSound() {
          System.out.println("Woof");
      }
  }

  public class Test {
      public static void main(String[] args) {
          Dog dog = new Dog();
          dog.makeSound(); // Output: Woof
          dog.sleep(); // Output: Zzz
      }
  }
  ```

## 8. **Generics**

### **Generic Classes**
- **Definition**: Generics enable types (classes and methods) to be parameters when defining classes, interfaces, and methods.
- **Example**:
  ```java
  public class Box<T> {
      private T content;

      public void set(T content) {
          this.content = content;
      }

      public T get() {
          return content;
      }
  }

  public class Test {
      public static void main(String[] args) {
          Box<String> stringBox = new Box<>();
          stringBox.set("Hello");
          System.out.println(stringBox.get()); // Output: Hello

          Box<Integer> intBox = new Box<>();
          intBox.set(123);
          System.out.println(intBox.get()); // Output: 123
      }
  }
  ```

### **Generic Methods**
- **Definition**: Methods that are defined with generic types that are specified when the method is called.
- **Example**:
  ```java
  public class Util {
      public static <T> void printArray(T[] array) {
          for (T element : array) {
              System.out.println(element);
          }
      }
  }

  public class Test {
      public static void main(String[] args) {
          Integer[] intArray = {1, 2, 3};
          Util.printArray(intArray); // Output: 1 2 3

          String[] strArray = {"a", "b", "c"};
          Util.printArray(strArray); // Output: a b c
      }
  }
  ```

### **Bounded Type Parameters**
- **Definition**: Allows you to restrict the types that can be used as arguments for type parameters.
- **Example**:
  ```java
  public class Util {
      public static <T extends Number> void printNumbers(T[] numbers) {
          for (T number : numbers) {
              System.out.println(number);
          }
      }
  }

  public class Test {
      public static void main(String[] args) {
          Integer[] intArray = {1, 2, 3};
          Util.printNumbers(intArray); // Output: 1 2 3

          Double[] doubleArray = {1.1, 2.2, 3.3};
          Util.printNumbers(doubleArray); // Output: 1.1 2.2 3.3
      }
  }
  ```

### **Wildcards**
- **Definition**: Wildcards are special placeholders used in generics to denote unknown types.
  - **Unbounded Wildcards**: `<?>`
  - **Bounded Wildcards**: `<? extends T>` (upper bound), `<? super T>` (lower bound)
- **Example**:
  ```java
  public class Util {
      public void processList(List<?> list) {
          // Can accept any list
          for (Object item : list) {
              System.out.println(item);
          }
      }

      public void processNumberList(List<? extends Number> list) {
          // Can accept lists of Number or its subclasses
          for (Number num : list) {
              System.out.println(num);
          }
      }
  }

  public class Test {
      public static void main(String[] args) {
          List<String> stringList = Arrays.asList("A", "B", "C");
          Util util = new Util();
          util.processList(stringList); // Output: A B C

          List<Integer> intList = Arrays.asList(1, 2, 3);
          util.processNumberList(intList); // Output: 1 2 3
      }
  }
  ```

## 9. **Annotations**

### **Built-in Annotations**
- **`@Override`**: Indicates that a method is overriding a method in a superclass.
- **`@Deprecated`**: Marks a method or class as deprecated, meaning it should not be used.
- **`@SuppressWarnings`**: Suppresses specific compiler warnings.
  ```java
  @SuppressWarnings("unchecked")
  public void uncheckedMethod() {
      // Code that may cause unchecked warnings
  }
  ```

### **Custom Annotations**
- **Definition**: Custom annotations are user-defined annotations created to add metadata to Java code.
- **Example**:
  ```java
  @Retention(RetentionPolicy.RUNTIME)
  @Target(ElementType.METHOD)
  public @interface Test {
      String value() default "test";
  }

  public class Example {
      @Test("myTest")
      public void testMethod() {
          // Test code
      }
  }
  ```

### **Annotation Processing**
- **Definition**: Annotation processing allows you to process annotations at compile time and generate code or validate annotations.
- **Example**:
  ```java
  @SupportedAnnotationTypes("com.example.Test")
  @SupportedSourceVersion(SourceVersion.RELEASE_8)
  public class TestAnnotationProcessor extends AbstractProcessor {
      @Override
      public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
          for (Element element : roundEnv.getElementsAnnotatedWith(Test.class)) {
              // Processing logic
              Test test = element.getAnnotation(Test.class);
              System.out.println("Test annotation value: " + test.value());
          }
          return true;
      }
  }
  ```

## 10. **Exception Handling**

### **Try-Catch-Finally**
- **Definition**: Used to handle exceptions and ensure cleanup operations.
- **Example**:
  ```java
  try {
      int result = 10 / 0;
  } catch (ArithmeticException e) {
      System.out.println("Cannot divide by zero.");
  } finally {
      System.out.println("This will always execute.");
  }
  ```

### **Throw and Throws**
- **`throw`**: Used to explicitly throw exceptions.
  - Example:
    ```java
    public void checkAge(int age) {
        if (age < 18) {
            throw new IllegalArgumentException("Age must be at least 18.");
        }
    }
    ```
- **`throws`**: Declares exceptions that a method might throw.
  - Example:
    ```java
    public void readFile(String filePath) throws IOException {
        FileReader fileReader = new FileReader(filePath);
        // Reading file
    }
    ```

## 11. **Synchronization**

### **Definition**
- **Synchronization**: A mechanism that ensures that only one thread can access a resource at a time to avoid concurrent access issues.

### **Synchronized Methods**
- **Definition**: Synchronize a method to allow only one thread to execute it at a time.
- **Example**:
  ```java
  public synchronized void synchronizedMethod() {
      // Code that needs to be synchronized
  }
  ```

### **Synchronized Blocks**
- **Definition**: Allows fine-grained control over synchronization by synchronizing a block of code instead of the entire method.
- **Example**:
  ```java
  public void method() {
      synchronized(this) {
          // Code that needs to be synchronized
      }
  }
  ```

## 12. **Reflection**

### **Definition**
- **Reflection**: A feature in Java that allows inspection and manipulation of classes, methods, fields, and other components at runtime.

### **Usage**
- **Example**:
  ```java
  public class Test {
      private String field = "Hello";

      public void method() {
          System.out.println("Method invoked");
      }
  }

  public class ReflectionDemo {
      public static void main(String[] args) throws Exception {
          Class<?> cls = Test.class;
          Object obj = cls.getDeclaredConstructor().newInstance();

          // Access private field
          Field field = cls.getDeclaredField("field");
          field.setAccessible(true);
          System.out.println("Field value: " + field.get(obj));

          // Invoke method
          Method method = cls.getDeclaredMethod("method");
          method.invoke(obj);
      }
  }
  ```

## 13. **Records**

### **Definition**
- **Records**: A special kind of class in Java introduced in JDK 14 as a preview feature and officially in JDK 16. Records are a special kind of class in Java that act as transparent carriers for immutable data.

### **Usage**
- **Syntax**:
  ```java
  public record Point(int x, int y) { }
  ```
  - **Implicit Methods**: Records automatically provide implementations for `equals()`, `hashCode()`, and `toString()` methods based on the fields.
  - **Example**:
    ```java
    public record Person(String name, int age) { }

    public class Test {
        public static void main(String[] args) {
            Person person = new Person("John", 30);
            System.out.println(person.name()); // Output: John
            System.out.println(person.age());  // Output: 30
            System.out.println(person);        // Output: Person[name=John, age=30]
        }
    }
    ```
  
## 14. **Java Modules**

### **Definition**
- **Java Modules**: Introduced in Java 9, modules allow you to group related packages and provide better encapsulation and versioning of your Java code. Modules help in creating more maintainable and scalable applications.

### **Module Declaration**
- **Syntax**:
  ```java
  module my.module {
      exports com.example.myapp;
      requires java.sql;
  }
  ```
  - **`exports`**: Specifies which packages are accessible to other modules.
  - **`requires`**: Specifies which modules are required by this module.

### **Creating a Module**
- **Example**:
  - Create a `module-info.java` file in the root of your source directory:
    ```java
    module mymodule {
        exports com.example;
    }
    ```
  - Structure your code accordingly:
    ```java
    package com.example;

    public class MyClass {
        public void display() {
            System.out.println("Hello from MyClass!");
        }
    }
    ```

## 15. **Best Practices and Conventions**

### **Naming Conventions**
- **Classes**: Use PascalCase (e.g., `MyClass`).
- **Methods**: Use camelCase (e.g., `myMethod`).
- **Variables**: Use camelCase (e.g., `myVariable`).
- **Constants**: Use UPPER_CASE_WITH_UNDERSCORES (e.g., `MAX_VALUE`).

### **Code Structure**
- **One Public Class Per File**: Each file should contain only one public class, and the file name should match the class name.
- **Main Method**: The `main` method should be the entry point of the program and should be `public static void main(String[] args)`.

### **Documentation**
- **Javadoc Comments**: Use Javadoc comments to document classes, methods, and fields. This helps generate documentation and provides a clear understanding of the code.
  ```java
  /**
   * Represents a simple class with a field and a method.
   */
  public class MyClass {
      /**
       * A field that stores an integer value.
       */
      private int value;

      /**
       * Sets the value of the field.
       * @param value The new value.
       */
      public void setValue(int value) {
          this.value = value;
      }

      /**
       * Gets the value of the field.
       * @return The value of the field.
       */
      public int getValue() {
          return value;
      }
  }
  ```

### **Error Handling**
- **Use Exceptions Properly**: Use exceptions to handle error conditions, not for flow control.
- **Catch Specific Exceptions**: Catch specific exceptions rather than using a general `Exception` to handle errors.

### **Performance**
- **Avoid Premature Optimization**: Focus on writing clean and maintainable code before optimizing for performance.
- **Use Efficient Data Structures**: Choose the appropriate data structures and algorithms based on your performance needs.

### **Thread Safety**
- **Avoid Shared Mutable State**: Minimize the use of shared mutable state to avoid synchronization issues.
- **Use Synchronization Appropriately**: Use synchronized blocks and methods to protect critical sections of code.
