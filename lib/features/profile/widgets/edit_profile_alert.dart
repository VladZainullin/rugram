import 'package:flutter/material.dart';
import 'package:rugram/features/profile/profile_state.dart';

import '../profile_cubit.dart';

class EditProfileAlert extends StatelessWidget {

  final ProfilePageState state;
  final String userId;
  final ProfilePageCubit profileCubit;


  const EditProfileAlert({super.key, required this.state, required this.userId, required this.profileCubit});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Редактирование профиля'),
              content: Column(children: [
                TextFormField(
                  controller: state.nameController(),
                  decoration: const InputDecoration(labelText: 'Введите имя'),
                ),
                TextFormField(
                  controller: state.surnameController(),
                  decoration:
                  const InputDecoration(labelText: 'Введите фамилию'),
                ),
              ]),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    profileCubit.updateAsync(
                        userId: userId,
                        name: state.nameController().text,
                        surname: state.surnameController().text);
                    Navigator.pop(context);
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      }(),
      child: const Center(
        child: Text(
          'Редактировать профиль',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}