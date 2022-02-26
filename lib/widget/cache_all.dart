part of 'main.dart';

class CacheWidget extends StatelessWidget {
  final BuildContext context;
  final List<int> trackIds;
  final String name;
  final int wait;

  const CacheWidget({
    Key? key,
    required this.context,
    required this.trackIds,
    required this.name,
    this.wait = 250,
  }) : super(key: key);

  Core get core => context.read<Core>();
  Audio get audio => core.audio;
  // AudioBucketType get cache => core.collection.cacheBucket;
  // List<AudioTrackType> get track => cache.track;

  @override
  Widget build(BuildContext context) {
    return WidgetChildBuilder(
      primary: true,
      show: true,
      child: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: wait), () => true),
        // future: Future.microtask(() => true),
        builder: (_, snap) {
          if (snap.hasData == false) return _holder();
          return _button();
        },
      ),
    );
  }

  Widget _button() {
    return StreamBuilder<AudioCacheType>(
      initialData: const AudioCacheType(),
      stream: audio.trackCacheCheckTesting(trackIds),
      builder: (context, snapshot) {
        final snap = snapshot.data ?? const AudioCacheType();

        final progress = snap.progress;
        final completed = snap.caching == 1.0;
        return WidgetButton(
          margin: const EdgeInsets.only(left: 10),
          child: SizedBox.square(
            dimension: 40,
            child: Stack(
              children: [
                Align(
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      value: snap.caching,
                      color: Theme.of(context).highlightColor,
                      backgroundColor: Theme.of(context).hintColor,
                      strokeWidth: 20,
                    ),
                  ),
                ),
                if (progress)
                  Align(
                    child: SizedBox.square(
                      dimension: 40,
                      child: CircularProgressIndicator(
                        value: completed ? 0.0 : null,
                        color: Theme.of(context).highlightColor.withOpacity(0.7),
                        strokeWidth: 5,
                      ),
                    ),
                  ),
                Align(
                  child: Icon(
                    completed ? Icons.cloud_done : Icons.cloud_download,
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {
            if (completed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  backgroundColor: Theme.of(context).backgroundColor,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  behavior: SnackBarBehavior.floating,
                  content: WidgetLabel(
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    label: '"$name" already available for Offline play',
                  ),
                ),
              );
            } else {
              audio.trackCacheDownloadTesting(trackIds);
            }
          },
          onLongPress: () {
            if (completed) {
              doConfirmWithDialog(
                context: context,
                title: 'Are you sure to remove',
                message: '..."$name" Offline caches?',
              ).then((confirmation) {
                if (confirmation != null && confirmation) {
                  audio.trackCacheClearTesting(trackIds);
                }
              });
            } else {
              audio.trackCacheDownloadTesting(trackIds);
            }
          },
        );
      },
    );
  }

  Widget _holder() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox.square(
        dimension: 40,
        child: Stack(
          children: [
            Align(
              child: SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  value: 0.0,
                  color: Theme.of(context).highlightColor,
                  backgroundColor: Theme.of(context).hintColor,
                  strokeWidth: 20,
                ),
              ),
            ),
            // Align(
            //   child: SizedBox.square(
            //     dimension: 40,
            //     child: CircularProgressIndicator(
            //       value: completed ? 0.0 : null,
            //       color: Theme.of(context).highlightColor.withOpacity(0.7),
            //       strokeWidth: 5,
            //     ),
            //   ),
            // ),
            Align(
              child: Icon(
                Icons.cloud_download,
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
