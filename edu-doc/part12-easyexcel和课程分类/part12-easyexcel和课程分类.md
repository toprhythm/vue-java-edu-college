# part12-easyexcel和课程分类

# 1 Excel导入导出的应用场景

## 1.1 数据导入

减轻录入工作量

## 1.2 数据导出

统计信息归档

## 1.3 数据传输

异构系统之间数据传输



# 2 EasyExcel简介

## 2.1 官方网站

https://github.com/alibaba/easyexcel

快速开始：https://www.yuque.com/easyexcel/doc/easyexcel

## 2.2 EasyExcel特点

- Java领域解析、生成Excel比较有名的框架有Apache poi、jxl等。但他们都存在一个严重的问题就是非常的耗内存。如果你的系统并发量不大的话可能还行，但是一旦并发上来后一定会OOM或者JVM频繁的full gc。
- EasyExcel是阿里巴巴开源的一个excel处理框架，**以使用简单、节省内存著称**。EasyExcel能大大减少占用内存的主要原因是在解析Excel时没有将文件数据一次性全部加载到内存中，而是从磁盘上一行行读取数据，逐个解析。
- EasyExcel采用一行一行的解析模式，并将一行的解析结果以观察者的模式通知处理（AnalysisEventListener）。



微商城

excel：
统计: 会员数量，会员信息，订单（根据会员id，商品id，根据日期）



# 3 创建独立的easyexcel项目

## 3.1 创建一个普通的maven项目

项目名：alibaba_easyexcel

## 3.2 pom中引入xml相关依赖

```xml
<dependencies>
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>easyexcel</artifactId>
        <version>2.1.7</version>
    </dependency>
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-simple</artifactId>
        <version>1.7.5</version>
    </dependency>
    <dependency>
        <groupId>org.apache.xmlbeans</groupId>
        <artifactId>xmlbeans</artifactId>
        <version>3.1.0</version>
    </dependency>
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>1.18.10</version>
    </dependency>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
    </dependency>
</dependencies>
```

# 4 最简单的excel写操作

## 4.1 创建实体类

```java
package com.yunzou.easyexcel.entity;

@Data
public class ExcelStudentData {
    @ExcelProperty("姓名")
    private String name;
    @ExcelProperty("生日")
    private Date birthday;
    @ExcelProperty("薪资")
    private Double salary;
    /**
     * 忽略这个字段
     */
    @ExcelIgnore
    private String password;
}

```

## 4.2 测试用例

- 07版本的Excel和03版本的写入方式有所不同
- 03版本的Excel写入最多一次可写65536行

```java
package com.atguigu.easyexcel;

public class ExcelWriteTest {
    /**
     * 最简单的写
     */
    @Test
    public void simpleWrite07() {
        String fileName = "d:/excel/01-simpleWrite-07.xlsx";
        // 这里 需要指定写用哪个class去写，然后写到第一个sheet，名字为模板 然后文件流会自动关闭
        EasyExcel.write(fileName, ExcelStudentData.class).sheet("模板").doWrite(data());
    }
    @Test
    public void simpleWrite03() {
        String fileName = "d:/excel/01-simpleWrite-03.xls";
        // 如果这里想使用03 则 传入excelType参数即可
        EasyExcel.write(fileName, ExcelStudentData.class).excelType(ExcelTypeEnum.XLS).sheet("模板").doWrite(data());
    }
    private List<ExcelStudentData> data(){
        List<ExcelStudentData> list = new ArrayList<>();
        //算上标题，做多可写65536行
        //超出：java.lang.IllegalArgumentException: Invalid row number (65536) outside allowable range (0..65535)
        for (int i = 0; i < 65535; i++) {
            ExcelStudentData data = new ExcelStudentData();
            data.setName("Helen" + i);
            data.setBirthday(new Date());
            data.setSalary(0.56);
            data.setPassword("123"); //即使设置也不会被导出
            list.add(data);
        }
        return list;
    }
}
```

# 5 指定写入列

为列配置 index 属性

```java
package com.atguigu.easyexcel.entity;

@Data
public class ExcelStudentData {
    @ExcelProperty(value = "姓名", index = 0)
    private String name;
    @ExcelProperty(value = "生日", index = 1)
    private Date birthday;
    /**
     * 这里设置3 会导致第二列空的
     */
    @ExcelProperty(value = "薪资", index = 3)
    private Double salary;
    /**
     * 忽略这个字段
     */
    @ExcelIgnore
    private String password;
}
```

# 6 自定义格式转换

配置@DateTimeFormat 和 @NumberFormat

```java
package com.atguigu.easyexcel.entity;

@Data
public class ExcelStudentData {
    @ExcelProperty(value = "姓名")
    private String name;
    @DateTimeFormat("yyyy年MM月dd日HH时mm分ss秒")
    @ExcelProperty(value = "生日")
    private Date birthday;
    @NumberFormat("#.##%")//百分比表示，保留两位小数
    @ExcelProperty(value = "薪资")
    private Double salary;
    /**
     * 忽略这个字段
     */
    @ExcelIgnore
    private String password;
}
```



# 7 最简单的读

## 7.1 参考文档

https://www.yuque.com/easyexcel/doc/read

## 7.2 创建监听器

```java
package com.atguigu.easyexcel.listener;

@Slf4j
public class ExcelStudentDataListener extends AnalysisEventListener<ExcelStudentData> {
    /**
     * 每隔5条存储数据库，实际使用中可以3000条，然后清理list ，方便内存回收
     */
    private static final int BATCH_COUNT = 5;
    List<ExcelStudentData> list = new ArrayList<>();
    /**
     * 这个每一条数据解析都会来调用
     *
     * @param data
     *            one row value. Is is same as {@link AnalysisContext#readRowHolder()}
     * @param context
     */
    @Override
    public void invoke(ExcelStudentData data, AnalysisContext context) {
        log.info("解析到一条数据:{}", data);
        list.add(data);
        // 达到BATCH_COUNT了，需要去存储一次数据库，防止数据几万条数据在内存，容易OOM
        if (list.size() >= BATCH_COUNT) {
            log.info("存数据库");
            // 存储完成清理 list
            list.clear();
        }
    }
    /**
     * 所有数据解析完成了 都会来调用
     *
     * @param context
     */
    @Override
    public void doAfterAllAnalysed(AnalysisContext context) {
        log.info("所有数据解析完成！");
    }
}
```

## 7.3 测试用例

```java
package com.atguigu.easyexcel;

public class ExcelReadTest {
    /**
     * 最简单的读
     */
    @Test
    public void simpleRead07() {
        String fileName = "d:/excel/01-simpleWrite-07.xlsx";
        // 这里默认读取第一个sheet
        EasyExcel.read(fileName, ExcelStudentData.class, new ExcelStudentDataListener()).sheet().doRead();
    }
    @Test
    public void simpleRead03() {
        String fileName = "d:/excel/01-simpleWrite-03.xls";
        // 这里默认读取第一个sheet
        EasyExcel.read(fileName, ExcelStudentData.class, new ExcelStudentDataListener()).excelType(ExcelTypeEnum.XLS).sheet().doRead();
    }
}
```

