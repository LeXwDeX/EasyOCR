# EasyOCR

[![PyPI 状态](https://badge.fury.io/py/easyocr.svg)](https://badge.fury.io/py/easyocr)
[![许可证](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/JaidedAI/EasyOCR/blob/master/LICENSE)
[![在 Colab 中打开](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.to/easyocr)
[![推文](https://img.shields.io/twitter/url/https/github.com/JaidedAI/EasyOCR.svg?style=social)](https://twitter.com/intent/tweet?text=Check%20out%20this%20awesome%20library:%20EasyOCR%20https://github.com/JaidedAI/EasyOCR)
[![Twitter](https://img.shields.io/badge/twitter-@JaidedAI-blue.svg?style=flat)](https://twitter.com/JaidedAI)

开箱即用的 OCR，支持 80 多种[语言](https://www.jaided.ai/easyocr)和所有主流书写体系，包括：拉丁文、中文、阿拉伯文、天城文、西里尔文等。

[在我们的网站上试用演示](https://www.jaided.ai/easyocr)

已集成到 [Huggingface Spaces 🤗](https://huggingface.co/spaces)，使用 [Gradio](https://github.com/gradio-app/gradio)。在线 Web 演示：[![Hugging Face Spaces](https://img.shields.io/badge/%F0%9F%A4%97%20Hugging%20Face-Spaces-blue)](https://huggingface.co/spaces/tomofi/EasyOCR)

## 更新日志
- 2024年9月24日 - 版本 1.7.2
    - 修复了若干兼容性问题

- [查看所有更新日志](https://github.com/JaidedAI/EasyOCR/blob/master/releasenotes.md)

## 即将推出
- 手写文字识别支持

## 示例

![示例](examples/example.png)

![示例2](examples/example2.png)

![示例3](examples/example3.png)

## 安装

使用 `pip` 安装

获取最新稳定版：

```bash
pip install easyocr
```

获取最新开发版：

```bash
pip install git+https://github.com/JaidedAI/EasyOCR.git
```

注意1：在 Windows 上，请先按照 https://pytorch.org 的官方说明安装 torch 和 torchvision。务必在 pytorch 网站选择你实际的 CUDA 版本。如果只打算在 CPU 模式下运行，请选择 `CUDA = None`。

注意2：我们也提供了 [Dockerfile](https://github.com/JaidedAI/EasyOCR/blob/master/Dockerfile)。

## 用法

```python
import easyocr
```

## Docker 运行与调用

你可以通过 Docker 方式运行 EasyOCR，适合隔离环境或批量处理。

**1. 构建镜像**
```bash
docker build -t easyocr:latest .
```

**2. 命令行方式调用**
假设本地有图片 `examples/chinese.jpg`：
```bash
docker run --rm -v ${PWD}/examples:/data easyocr:latest \
  python /home/EasyOCR/easyocr/cli.py -l ch_sim --file /data/chinese.jpg
```
说明：`-v ${PWD}/examples:/data` 将本地图片目录挂载到容器内，便于访问。

**3. Python 脚本方式调用**
假设有自定义脚本 `my_ocr.py`，内容如下：
```python
import easyocr
reader = easyocr.Reader(['ch_sim', 'en'])
result = reader.readtext('/data/chinese.jpg')
print(result)
```
运行方式：
```bash
docker run --rm -v ${PWD}/examples:/data -v ${PWD}/my_ocr.py:/home/EasyOCR/my_ocr.py easyocr:latest \
  python /home/EasyOCR/my_ocr.py
```

**4. 进阶：API 部署**
如需 API 方式部署，可在容器内自行添加 Flask/FastAPI 服务并暴露端口。

reader = easyocr.Reader(['ch_sim','en']) # 只需运行一次以将模型加载到内存
result = reader.readtext('chinese.jpg')
```

输出将以列表形式返回，每一项分别为：检测到的文本框、识别出的文本和置信度。

```bash
[([[189, 75], [469, 75], [469, 165], [189, 165]], '愚园路', 0.3754989504814148),
 ([[86, 80], [134, 80], [134, 128], [86, 128]], '西', 0.40452659130096436),
 ([[517, 81], [565, 81], [565, 123], [517, 123]], '东', 0.9989598989486694),
 ([[78, 126], [136, 126], [136, 156], [78, 156]], '315', 0.8125889301300049),
 ([[514, 126], [574, 126], [574, 156], [514, 156]], '309', 0.4971577227115631),
 ([[226, 170], [414, 170], [414, 220], [226, 220]], 'Yuyuan Rd.', 0.8261902332305908),
 ([[79, 173], [125, 173], [125, 213], [79, 213]], 'W', 0.9848111271858215),
 ([[529, 173], [569, 173], [569, 213], [529, 213]], 'E', 0.8405593633651733)]
```
注意1：`['ch_sim','en']` 是你希望识别的语言列表。你可以同时传入多种语言，但并非所有语言都能兼容。英语可与任意语言兼容，共用字符的语言通常也能兼容。

注意2：除了文件路径 `chinese.jpg`，你还可以传入 OpenCV 图像对象（numpy 数组）、图片字节流，或图片的原始 URL。

注意3：`reader = easyocr.Reader(['ch_sim','en'])` 这行代码用于加载模型到内存，首次运行会较慢，但只需运行一次。

你也可以设置 `detail=0` 获取更简洁的输出。

```python
reader.readtext('chinese.jpg', detail = 0)
```
结果：
```bash
['愚园路', '西', '东', '315', '309', 'Yuyuan Rd.', 'W', 'E']
```

所选语言的模型权重会自动下载，或可从 [model hub](https://www.jaided.ai/easyocr/modelhub) 手动下载并放到 '~/.EasyOCR/model' 文件夹下。

如果没有 GPU，或 GPU 显存较小，可以通过添加 `gpu=False` 以仅用 CPU 运行。

```python
reader = easyocr.Reader(['ch_sim','en'], gpu=False)
```

更多信息请阅读[教程](https://www.jaided.ai/easyocr/tutorial)和[API 文档](https://www.jaided.ai/easyocr/documentation)。

#### 命令行运行

```shell
$ easyocr -l ch_sim en -f chinese.jpg --detail=1 --gpu=True
```

## 训练/使用自定义模型

识别模型请[参考这里](https://github.com/JaidedAI/EasyOCR/blob/master/custom_model.md)。

检测模型（CRAFT）请[参考这里](https://github.com/JaidedAI/EasyOCR/blob/master/trainer/craft/README.md)。

## 实现路线图

- 手写体支持
- 重构代码以支持可切换的检测和识别算法
API 应该像这样简单
```python
reader = easyocr.Reader(['en'], detection='DB', recognition = 'Transformer')
```
我们的目标是让任何最先进的模型都能快速集成到 EasyOCR。许多天才都在努力开发更好的检测/识别模型，我们的目标不是成为天才，而是让他们的成果能被大众快速免费使用。（我们相信大多数天才都希望自己的成果能尽快产生最大影响）流程如下图所示，灰色部分为可更换的浅蓝色模块占位。

![plan](examples/easyocr_framework.jpeg)

## 鸣谢与参考

本项目基于多篇论文和开源项目的研究与代码。

所有深度学习部分基于 [Pytorch](https://pytorch.org)。:heart:

检测部分使用了 CRAFT 算法，来自[官方仓库](https://github.com/clovaai/CRAFT-pytorch)和[论文](https://arxiv.org/abs/1904.01941)（感谢 [@YoungminBaek](https://github.com/YoungminBaek) 和 [@clovaai](https://github.com/clovaai)）。我们也使用了他们的预训练模型。训练脚本由 [@gmuffiness](https://github.com/gmuffiness) 提供。

识别模型为 CRNN（[论文](https://arxiv.org/abs/1507.05717)），由三部分组成：特征提取（目前用 [Resnet](https://arxiv.org/abs/1512.03385) 和 VGG）、序列标注（[LSTM](https://www.bioinf.jku.at/publications/older/2604.pdf)）和解码（[CTC](https://www.cs.toronto.edu/~graves/icml_2006.pdf)）。识别训练流程基于 [deep-text-recognition-benchmark](https://github.com/clovaai/deep-text-recognition-benchmark) 框架的修改版。（感谢 [@ku21fan](https://github.com/ku21fan) 和 [@clovaai](https://github.com/clovaai)）该仓库非常优秀，值得更多关注。

Beam search 代码基于[此仓库](https://github.com/githubharald/CTCDecoder)和[他的博客](https://towardsdatascience.com/beam-search-decoding-in-ctc-trained-neural-networks-5a889a3d85a7)。（感谢 [@githubharald](https://github.com/githubharald)）

数据合成基于 [TextRecognitionDataGenerator](https://github.com/Belval/TextRecognitionDataGenerator)。（感谢 [@Belval](https://github.com/Belval)）

关于 CTC 的好文章可见 distill.pub [这里](https://distill.pub/2017/ctc/)。

## 想要贡献？

让我们一起推动人类进步，让 AI 惠及每个人！

三种贡献方式：

**开发者：** 小问题/改进请直接提交 PR。较大的变更请先通过 issue 与我们讨论。可在 ['PR WELCOME'](https://github.com/JaidedAI/EasyOCR/issues?q=is%3Aissue+is%3Aopen+label%3A%22PR+WELCOME%22) 标签下找到可参与的问题。

**用户：** 欢迎分享 EasyOCR 如何帮助了你/你的组织，以激励我们持续开发。也请在 [Issue 区](https://github.com/JaidedAI/EasyOCR/issues) 反馈失败案例，帮助我们改进模型。

**技术领袖/专家：** 如果你觉得本库有用，请帮忙宣传！（见 [Yann Lecun 的帖子](https://www.facebook.com/yann.lecun/posts/10157018122787143)）

## 新语言请求指南

如需请求新语言，请提交包含以下两类文件的 PR：

1. 在 [easyocr/character](https://github.com/JaidedAI/EasyOCR/tree/master/easyocr/character) 文件夹下，提供 'yourlanguagecode_char.txt'，内容为该语言所有字符。可参考该文件夹下其他文件格式。
2. 在 [easyocr/dict](https://github.com/JaidedAI/EasyOCR/tree/master/easyocr/dict) 文件夹下，提供 'yourlanguagecode.txt'，内容为该语言的单词列表。平均每种语言约 3 万词，热门语言超过 5 万词，越多越好。

如果你的语言有特殊性（如 1. 阿拉伯文：字符连写时形态变化且从右到左书写 2. 泰文：部分字符需上下叠加），请尽量详细说明或提供有用链接。细节决定系统效果。

请理解，我们会优先支持流行语言或字符集重叠度高的语言（如你的语言属于此类请告知）。开发新模型至少需一周时间，敬请耐心等待。

见[开发中语言列表](https://github.com/JaidedAI/EasyOCR/issues/91)

## Github 问题反馈

由于资源有限，6 个月以上的 issue 会自动关闭。如有重要问题请重新提交。

## 商业合作

如需企业级支持，[Jaided AI](https://www.jaided.ai/) 可为定制 OCR/AI 系统提供全流程服务，包括实现、训练/微调和部署。点击[这里](https://www.jaided.ai/contactus?ref=github)联系我们。
