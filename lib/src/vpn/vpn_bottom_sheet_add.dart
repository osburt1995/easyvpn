import 'package:easyvpn/model/server.dart';
import 'package:easyvpn/providers/servers_provider.dart';
import 'package:easyvpn/src/screens/home_screen.dart';
import 'package:easyvpn/src/vpn/vpn_page.dart';
import 'package:easyvpn/utils/server_service.dart';
import 'package:easyvpn/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:formdator/formdator.dart';
import 'package:provider/provider.dart';

class VpnBottomSheetAdd extends StatefulWidget {
  @override
  _VpnBottomSheetAddState createState() => _VpnBottomSheetAddState();
}

class _VpnBottomSheetAddState extends State<VpnBottomSheetAdd> {
  // The input data.
  final Map<String, dynamic> _data = {};

  // The form's mandatory key.
  final _fkey = GlobalKey<FormState>();

  // 返回上个页面
  back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: GestureDetector(
              onTap: () => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()))
              },
              child: Icon(Icons.arrow_back),
            ),
            title: Text(
              '添加VPN配置',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: buildBody(context)),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Expanded(
          child: Form(
            key: _fkey,
            child: Column(
              children: [
                _ServerField(onSaved: _saveServer),
                _UsernameField(
                  label: '用户名',
                  //onChanged: _refreshPass,
                  onSaved: _saveUsername,
                ),
                _PasswordField(
                  label: '密码',
                  //onChanged: _refreshConfirm,
                  onSaved: _savePass,
                  //extra: Equal(_enteredPass, diff: 'does not match.'),
                ),
                _SubField(
                  label: '配置名称',
                  onSaved: _saveSub,
                ),
                _ClearSubmitBar(fkey: _fkey, data: _data),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// The current entered password value.
  String _enteredPass() => (_data['pass'] as String) ?? '';

  /// Refreshes the password value.
  void _refreshPass(String value) => _data['pass'] = value;

  /// Refreshes the password confirmation value.
  void _refreshConfirm(String value) => _data['confirm'] = value;

  void _saveServer(String server) {
    if (server != null && server.isNotEmpty) {
      _data['address'] = server;
    }
  }

  void _saveUsername(String username) {
    if (username != null && username.isNotEmpty) {
      _data['username'] = username;
    }
  }

  void _savePass(String pass) {
    if (pass != null && pass.isNotEmpty) {
      _data['password'] = pass;
    }
  }

  void _saveSub(String sub) {
    if (sub != null && sub.isNotEmpty) {
      _data['name'] = sub;
    }
  }
}

/// Callback form onChange event.
typedef OnChanged = void Function(String);

/// Callback for onSave event.
typedef OnSaved = void Function(String);

class _UsernameField extends StatelessWidget {
  /// A form field that is suitable for entering sensitive data.
  ///
  /// [label] a descriptive text for the field.
  /// [onChange] the callback for data chage event.
  /// [onSaved] the callback for data saved event.
  /// [extra] an optional extra validation step.
  _UsernameField({
    String label,
    OnChanged onChanged,
    OnSaved onSaved,
    ValObj extra,
    Key key,
  })  : _label = label,
        _onChanged = onChanged,
        _onSaved = onSaved,
        _extra = extra ?? const Ok().call,
        // a dummy validator as default.
        super(key: key);

  final String _label;
  final OnChanged _onChanged;
  final OnSaved _onSaved;
  final ValObj _extra;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: _onSaved,
      onChanged: _onChanged,
      // validator: Pair(
      //   ReqLen.range(4, 8, short: 'at least 4 chars', long: 'at most 8 chars'),
      //   _extra,
      // ),
      validator: (value) {
        if (value.isEmpty) {
          return '用户名必填';
        }
        return null;
      },
      //keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: _label,
        //filled: true,
        icon: const Icon(Icons.supervisor_account),
        hintText: '请输入用户名',
      ),
    );
  }
}

/// Convenient form field for sensitive data.
class _PasswordField extends StatelessWidget {
  /// A form field that is suitable for entering sensitive data.
  ///
  /// [label] a descriptive text for the field.
  /// [onChange] the callback for data chage event.
  /// [onSaved] the callback for data saved event.
  /// [extra] an optional extra validation step.
  _PasswordField({
    String label,
    OnChanged onChanged,
    OnSaved onSaved,
    ValObj extra,
    Key key,
  })  : _label = label,
        _onChanged = onChanged,
        _onSaved = onSaved,
        _extra = extra ?? const Ok().call,
        // a dummy validator as default.
        super(key: key);

  final String _label;
  final OnChanged _onChanged;
  final OnSaved _onSaved;
  final ValObj _extra;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: _onSaved,
      onChanged: _onChanged,
      // validator: Pair(
      //   ReqLen.range(4, 8, short: 'at least 4 chars', long: 'at most 8 chars'),
      //   _extra,
      // ),
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: _label,
        // filled: true,
        icon: const Icon(Icons.password),
        hintText: '请输入密码',
      ),
    );
  }
}

class _SubField extends StatelessWidget {
  /// A form field that is suitable for entering sensitive data.
  ///
  /// [label] a descriptive text for the field.
  /// [onChange] the callback for data chage event.
  /// [onSaved] the callback for data saved event.
  /// [extra] an optional extra validation step.
  _SubField({
    String label,
    OnChanged onChanged,
    OnSaved onSaved,
    ValObj extra,
    Key key,
  })  : _label = label,
        _onChanged = onChanged,
        _onSaved = onSaved,
        _extra = extra ?? const Ok().call,
        // a dummy validator as default.
        super(key: key);

  final String _label;
  final OnChanged _onChanged;
  final OnSaved _onSaved;
  final ValObj _extra;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: _onSaved,
      onChanged: _onChanged,
      // validator: Pair(
      //   ReqLen.range(4, 8, short: 'at least 4 chars', long: 'at most 8 chars'),
      //   _extra,
      // ),
      //keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: _label,
        //filled: true,
        icon: const Icon(Icons.web),
        hintText: '配置名称(可选)',
      ),
    );
  }
}

/// Email field widget — it trims and validates an email so that it is neither
/// blank nor malformed.
class _ServerField extends StatelessWidget {
  /// Non-blank well-formed email with an optional [extra] validation step.
  ///
  /// [onSaved] callback for email saved event.
  const _ServerField({OnSaved onSaved, Key key})
      : _onSaved = onSaved,
        super(key: key);

  final OnSaved _onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: _onSaved,
      //validator: Trim(ReqEmail.len(50)),
      validator: (value) {
        if (value.isEmpty) {
          return '服务器地址必填';
        }
        return null;
      },
      keyboardType: TextInputType.url,
      decoration: const InputDecoration(
        labelText: '服务器地址',
        //filled: true,
        icon: Icon(Icons.dns),
        hintText: '请添加服务器或ip地址',
      ),
    );
  }
}

/// A clear and submit buttons within a Row widget.
class _ClearSubmitBar extends StatelessWidget {
  /// Encapsulates the form state.
  const _ClearSubmitBar({
    @required GlobalKey<FormState> fkey,
    @required Map<String, dynamic> data,
    Key key,
  })  : _fkey = fkey,
        _data = data,
        super(key: key);

  final GlobalKey<FormState> _fkey;
  final Map<String, dynamic> _data;

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: <Widget>[
        TextButton(
          onPressed: () {
            _data.clear();
            _fkey.currentState?.reset();
          },
          child: const Text('重置'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_fkey.currentState?.validate() ?? false) {
              _fkey.currentState?.save();
              Toast.show('保存成功');
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen()));
              //_showDialog(context);
              ServerSercice.setData('servers', _data);
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }

  /// Displays a success dialog.
  void _showDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('保存成功 '),
        content: const Text('VPN配置信息被保存'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, '完成'),
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }
}
