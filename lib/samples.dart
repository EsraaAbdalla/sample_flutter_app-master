import 'package:vdocipher_flutter/vdocipher_flutter.dart';

/// Replace media id, otp, playback info with one of your account.
const EmbedInfo sample_1 = EmbedInfo.streaming(
  otp: '20160313versASE323IrBEeRImgHnKB41CCMf5O4n25CPkNe6Jm7hjrUA68B4rKn',
  playbackInfo:
      'eyJ2aWRlb0lkIjoiZWFiMTU2ZWM3ODM3NGRjYzk1NTFhMDIwNTU1MmRkYTcifQ==',
  embedInfoOptions: EmbedInfoOptions(autoplay: true),
);

const EmbedInfo sample_2 = EmbedInfo.streaming(
  otp: "20160313versASE323giSlbnY7WMLHnUClCe1QYaLuGfjw3e87erKTYmmT16cWYm",
  playbackInfo:
      "eyJ2aWRlb0lkIjoiNTM3YWMzNTk3ZGQ0YTMwMjQyNTA3ZjI3YzhjOWY2ODAifQ==",
  embedInfoOptions: EmbedInfoOptions(
    nativeControls: true,
  ),
);
