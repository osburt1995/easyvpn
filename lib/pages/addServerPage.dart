import 'package:easyvpn/app/global_data.dart';
import 'package:easyvpn/model/server.dart';
import 'package:easyvpn/utils/storage.dart';
import 'package:easyvpn/widgets/progress_indicator.dart';

// import 'package:flutter/material.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../model/UserPreference.dart';
import '../model/themeCollection.dart';
import '../utils/customlaunch.dart';

class BooleanObject {
  final String name;

  BooleanObject(this.name);

  @override
  bool operator ==(Object other) =>
      other is BooleanObject && name == other.name;

  @override
  int get hashCode => hashValues(name, name);
}

final yes = BooleanObject('Yes');
final no = BooleanObject('No');

class AddServerPage extends StatefulWidget {
  const AddServerPage({Key? key}) : super(key: key);

  @override
  _AddServerPageState createState() => _AddServerPageState();
}

class _AddServerPageState extends State<AddServerPage> {
  FormGroup buildForm() =>
      fb.group(<String, Object>{
        'address': FormControl<String>(
          validators: [Validators.required],
          // asyncValidators: [_uniqueEmail],
        ),
        'username': FormControl<String>(
          validators: [Validators.required],
          // asyncValidators: [_uniqueEmail],
        ),
        'password': FormControl<String>(
          validators: [Validators.required],
          // asyncValidators: [_uniqueEmail],
        ),
        'name': FormControl<String>(
          // validators: [Validators.required],
          // asyncValidators: [_uniqueEmail],
        ),
      });

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeCollection>(context);
    bool isDarkTheme = Provider
        .of<ThemeCollection>(context)
        .isDarkActive;
    var countDown = Provider.of<UserPreference>(context);
    return Container(
      padding: EdgeInsets.only(
        top: 10.h,
      ),
      //height: MediaQuery.of(context).size.height * 0.8,
      //color: AppColor.BLACK,
      child: SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.deepOrange),
              onPressed: () => Navigator.of(context).pop(),
            ),
            //backgroundColor: AppColor.BLACK,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: ReactiveFormBuilder(
              form: buildForm,
              builder: (context, form, child) {
                return Column(
                  children: [
                    ReactiveTextField<String>(
                      style: Theme
                          .of(context)
                          .primaryTextTheme
                          .titleMedium,
                      formControlName: 'address',
                      validationMessages: (control) =>
                      {
                        ValidationMessage.required:
                        '服务器地址不能为空',
                      },
                      onSubmitted: () => form.focus('username'),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkTheme
                            ? const Color(0xff181227)
                            : const Color(0xffF5F5F6),
                        labelText: '服务器地址',
                        labelStyle:
                        Theme
                            .of(context)
                            .primaryTextTheme
                            .titleMedium,
                        // suffixIcon: ReactiveStatusListenableBuilder(
                        //   formControlName: 'address',
                        //   builder: (context, control, child) => Visibility(
                        //     visible: control.pending,
                        //     child: ProgressIndicator(),
                        //   ),
                        // ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ReactiveTextField<String>(
                      style: Theme
                          .of(context)
                          .primaryTextTheme
                          .titleMedium,
                      formControlName: 'username',
                      //obscureText: true,
                      validationMessages: (control) =>
                      {
                        ValidationMessage.required:
                        '用户名不能为空',
                      },
                      onSubmitted: () => form.focus('password'),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkTheme
                            ? const Color(0xff181227)
                            : const Color(0xffF5F5F6),
                        labelText: '用户名',
                        labelStyle:
                        Theme
                            .of(context)
                            .primaryTextTheme
                            .titleMedium,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ReactiveTextField<String>(
                      style: Theme
                          .of(context)
                          .primaryTextTheme
                          .titleMedium,
                      formControlName: 'password',
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkTheme
                            ? const Color(0xff181227)
                            : const Color(0xffF5F5F6),
                        labelText: '密码',
                        labelStyle:
                        Theme
                            .of(context)
                            .primaryTextTheme
                            .titleMedium,
                      ),
                      //obscureText: true,
                      validationMessages: (control) =>
                      {
                        ValidationMessage.required:
                        '密码不能为空',
                      },
                      //onSubmitted: () => form.focus('rememberMe'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 24.0),
                    ReactiveTextField<String>(
                      style: Theme
                          .of(context)
                          .primaryTextTheme
                          .titleMedium,
                      formControlName: 'name',
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkTheme
                            ? const Color(0xff181227)
                            : const Color(0xffF5F5F6),
                        labelText: '配置名(可选)',
                        labelStyle:
                        Theme
                            .of(context)
                            .primaryTextTheme
                            .titleMedium,
                      ),
                      // obscureText: true,
                      // validationMessages: (control) => {
                      //   ValidationMessage.required:
                      //   'The password must not be empty',
                      // },
                      //onSubmitted: () => form.focus('rememberMe'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlatButton(
                            color: const Color(0xff353351),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () {
                              form.resetState({
                                // 'email': ControlState<String>(
                                //     value: 'johnDoe', disabled: true),
                                // 'progress': ControlState<double>(value: 50.0),
                                // 'rememberMe': ControlState<bool>(value: false),
                              }, removeFocus: true);
                            },
                            child: const Text('重置')),
                        ReactiveFormConsumer(
                          builder: (context, form, child) =>
                              FlatButton(
                                  color: const Color(0xff6622CC),
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    if (form.valid) {
                                      countDown.addServer(Server.fromJson(form.value));
                                      Navigator.of(context).pop();
                                    }
                                    // print(Storage.getObjectList(
                                    //     GlobalData.SERVERS_LIST));
                                    // Storage.getObjectList(
                                    //     GlobalData.SERVERS_LIST)?.forEach((element) {print(Server.fromJson(element));});
                                    // countDown.serversList?.forEach((element) {
                                    //   print(element.name);
                                    // });
                                    // print();
                                    print(countDown.serversList);
                                  },
                                  child: const Text('保存')),
                        ),
                      ],
                    ),
                    Card(
                      elevation: 6,
                      color: isDarkTheme
                          ? const Color(0xff181227)
                          : const Color(0xffF5F5F6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Builder(builder: (context) {
                        // currentLocIndex =
                        //     Provider.of<UserPreference>(context).locationIndex;
                        return ListTile(
                          selectedColor: isDarkTheme
                              ? const Color(0xff38323F)
                              : const Color(0xffC7B4E3),
                          onTap: () {
                            customLaunch(
                                'https://github.com/shipinbaoku/ikev2-vpn-setup-bash');
                            // Navigator.of(context).pop();
                          },
                          onLongPress: () {},
                          // leading: SvgPicture.asset(
                          //   'assets/flags/${Flags.list[index]['imagePath']}',
                          //   width: 42,
                          // ),
                          title: Text(
                            '还没有专属的ikev2服务?',
                            style:
                            Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                          trailing: Icon(
                            Icons.navigate_next_rounded,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          subtitle: Text('一键在自己的服务器上建立属于自己的ikev2服务',
                              style:
                              Theme.of(context).primaryTextTheme.caption),
                        );
                      }),
                    ),
                    Card(
                      elevation: 6,
                      color: isDarkTheme
                          ? const Color(0xff181227)
                          : const Color(0xffF5F5F6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Builder(builder: (context) {
                        // currentLocIndex =
                        //     Provider.of<UserPreference>(context).locationIndex;
                        return ListTile(
                          selectedColor: isDarkTheme
                              ? const Color(0xff38323F)
                              : const Color(0xffC7B4E3),
                          onTap: () {
                            customLaunch(
                                'https://t.me/easyvpnchannel');
                            // Navigator.of(context).pop();
                          },
                          onLongPress: () {},
                          // leading: SvgPicture.asset(
                          //   'assets/flags/${Flags.list[index]['imagePath']}',
                          //   width: 42,
                          // ),
                          title: Text(
                            '关注我们的频道',
                            style:
                            Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                          trailing: Icon(
                            Icons.navigate_next_rounded,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          subtitle: Text('收听我们的频道获取更多教程和使用帮助',
                              style:
                              Theme.of(context).primaryTextTheme.caption),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// /// Async validator in use emails example
// const inUseEmails = ['johndoe@email.com', 'john@email.com'];
//
// /// Async validator example that simulates a request to a server
// /// to validate if the email of the user is unique.
// Future<Map<String, dynamic>?> _uniqueEmail(
//     AbstractControl<dynamic> control) async {
//   final error = {'unique': false};
//
//   final emailAlreadyInUse = await Future.delayed(
//     const Duration(seconds: 5), // delay to simulate a time consuming operation
//     () => inUseEmails.contains(control.value.toString()),
//   );
//
//   if (emailAlreadyInUse) {
//     control.markAsTouched();
//     return error;
//   }
//
//   return null;
// }
