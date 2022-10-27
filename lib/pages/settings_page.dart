import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/provider/schedule_provider.dart';
import 'package:flutter_restaurant_app/widgets/platform_widget.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/setting-page';
  const SettingsPage({Key? key}) : super(key: key);

  Widget _buildContent(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Material(
          child: ListTile(
            title: const Text('Saran Restoran'),
            subtitle: const Text('Kamu akan menerima notifikasi saran restoran dari kami'),
            trailing: Consumer<ScheduleProvider>(
              builder: (context, scheduled, _) {
                return Switch.adaptive(
                  value: scheduled.isScheduled,
                  onChanged: (value) async {
                    scheduled.setScheduledStatus(value);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAndroid(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Pengaturan",
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                color: Colors.white
              ),
            )
        ),
        body: _buildContent(context)
    );
  }

  Widget _buildIos(BuildContext context){
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            "Pengaturan",
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
              color: Colors.white
            ),
          ),
          transitionBetweenRoutes: false,
        ),
        child: _buildContent(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
