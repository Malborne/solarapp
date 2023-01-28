import 'package:flutter/material.dart';
class EnableLocDialog extends StatelessWidget {
  const EnableLocDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SimpleDialog(
      title: const Text('Enable Location Services'),
      backgroundColor: Colors.black45,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
        ),
        const SizedBox(
          height: 30,
        ),
        const Center(child:  Text('Please Enable Location Services')),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Okay',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            Expanded(
              child: SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
