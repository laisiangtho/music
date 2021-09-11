part of 'main.dart';

mixin _Board on _State {

  Widget board(){
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 150,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextButton(
                child: Chip(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                  avatar: const Icon(ZaideihIcon.track),
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('discover thousand'),
                      const Text('of in your'),
                      const Text('language')
                    ],
                  ),
                ),
                onPressed: () => core.navigate(to: '/'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                child: Chip(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                  avatar: const Icon(ZaideihIcon.artist),
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('find your favorite'),
                      const Text('Artists'),
                      const Text('& more'),
                    ],
                  ),
                ),
                onPressed: ()=>core.navigate(to: '/artist'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                child: Chip(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                  avatar: const Icon(ZaideihIcon.album),
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('In addition to get'),
                      const Text('detail information'),
                      const Text('about the Album'),
                    ],
                  ),
                ),
                onPressed: ()=>core.navigate(to: '/album'),
              ),
            )
          ],
        ),
      )
    );
  }
}
