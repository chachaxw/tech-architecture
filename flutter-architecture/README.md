# Flutter-Architecture

Flutter技术架构研究和学习，Flutter technology architecture study and learn

## Flutter技术架构概览

![Architectural diagram](images/archdiagram.png)

* Embedder是一个嵌入层，即把Flutter嵌入到各个平台上去，这里做的主要工作包括渲染Surface设置，线程设置，以及插件等。 从这里可以看出，Flutter的平台相关层很低，平台(如iOS)只是提供一个画布，剩余的所有渲染相关的逻辑都在Flutter内部，这就使得它具有了很好的跨端一致性
* Engine 是Flutter的核心，它主要是用C++编写的，并支持所有Flutter应用程序所必需的原语。每当需要绘制新界面时，引擎负责对合成场景进行栅格化。它提供了Flutter核心API的低级实现，包括图形（通过Skia），文本布局，文件和网络I / O，可访问性支持，插件架构以及Dart运行时和编译工具链
* Framework使用dart实现，包括Material Design风格的Widget, Cupertino(针对iOS)风格的Widgets，文本/图片/按钮等基础Widgets，渲染，动画，手势等。此部分的核心代码是: flutter仓库下的flutter package，以及flutter/engine仓库下的io, async, ui(dart:ui库提供了Flutter框架和引擎之间的接口)等package

## Flutter编译产物

![Flutter Artifact](images/flutter_artifact.png)


## 🔭 学习更多

* [Flutter architecture overview](https://flutter.dev/docs/resources/architectural-overview)
* [Flutter 跨平台演进及架构开篇](http://gityuan.com/flutter/)
