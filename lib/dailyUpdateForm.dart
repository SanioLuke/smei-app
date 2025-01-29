import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smei_workspace/profile.dart';

import 'di/dep.dart';


class ExpandableCardFormApp extends StatefulWidget {
  @override
  ExpandableCardFormAppState createState() => ExpandableCardFormAppState();
}

class ExpandableCardFormAppState extends State<StatefulWidget> {
  List<Map<String, dynamic>> cardData = [
    {"title": "Nutritions", "icon": Icons.fastfood, 'key': GlobalKey<_ExpandableCardFormState>()},
    {"title": "Studies", "icon": Icons.book,  'key': GlobalKey<_ExpandableCardFormState>()},
    {"title": "Behaviour", "icon": Icons.sentiment_satisfied,  'key': GlobalKey<_ExpandableCardFormState>()},
    {"title": "Self Control", "icon": Icons.self_improvement,  'key': GlobalKey<_ExpandableCardFormState>()},
    {"title": "Family Contribution", "icon": Icons.family_restroom, 'key': GlobalKey<_ExpandableCardFormState>()},
  ];

  List<GlobalKey<FormState>> formKeys =
  List.generate(5, (index) => GlobalKey<FormState>());

  /*Future<void> _submitForm() async {
    bool allValid = true;
    final Map<Object, Object> res = {};
    var index = 0;

    final userEntryDataRef = Get.find<Dependencies>().userEntryDataRef();
    final Map userEntryData = await userEntryDataRef.get().then((v) => Map.from(v.data()!));

    final currentDate = DateTime.now();
    final ddMMYYYY = "${currentDate.day}/${currentDate.month}/${currentDate.year}";

    for (var key in formKeys) {
      if (!key.currentState!.validate()) {
        allValid = false;
      } else {
        final ctrs = cardData[index]["key"].currentWidget;
        if (userEntryData[ddMMYYYY] == null && ctrs != null) {
          res[ctrs.title] = ctrs.controllers.map((e) => e.text).toList(growable: false);
        } else {
          Fluttertoast.showToast(msg: "You have already submitted the form for today");
          break;
        }
        key.currentState!.save();
      }
      index++;
    }

    if (allValid) {
      userEntryDataRef.update({
        'daily_update': {
          ddMMYYYY: res
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form Submitted Successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields')),
      );
    }
  }*/
  Future<void> _submitForm() async {
    bool allValid = true;
    final Map<Object, Object> res = {};
    var index = 0;

    final userEntryDataRef = Get.find<Dependencies>().userEntryDataRef();
    final Map userEntryData = await userEntryDataRef.get().then((v) => Map.from(v.data()!));

    final currentDate = DateTime.now();
    final ddMMYYYY = "${currentDate.day}/${currentDate.month}/${currentDate.year}";

    for (var key in formKeys) {
      if (!key.currentState!.validate()) {
        allValid = false;
      } else {
        final ctrs = cardData[index]["key"].currentWidget;
        if (userEntryData[ddMMYYYY] == null && ctrs != null) {
          res[ctrs.title] = ctrs.controllers.map((e) => e.text).toList(growable: false);
        } else {
          Fluttertoast.showToast(msg: "You have already submitted the form for today");
          break;
        }
        key.currentState!.save();
      }
      index++;
    }

    if (allValid) {
      await userEntryDataRef.update({
        'daily_update': {ddMMYYYY: res}
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form Submitted Successfully')),
      );

      // Navigate to ProfilePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Updates')),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(5, (index) {
            return ExpandableCardForm(
              formKey: formKeys[index],
              title: cardData[index]["title"],
              icon: cardData[index]["icon"],
              rootKey: cardData[index]["key"],
            );
          })
            ..add(SizedBox(height: 20))
            ..add(ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            )),
        ),
      ),
    );
  }
}

class ExpandableCardForm extends StatefulWidget {
  final String title;
  final IconData icon;
  final GlobalKey<FormState> formKey;
  List<TextEditingController> controllers =
  List.generate(10, (index) => TextEditingController());

  ExpandableCardForm({
    required this.formKey,
    required this.title,
    required this.icon,
    required Key? rootKey,
  }): super(key: rootKey);


  @override
  _ExpandableCardFormState createState() => _ExpandableCardFormState();
}

class _ExpandableCardFormState extends State<ExpandableCardForm> {
  bool isExpanded = false;
  bool hasError = false;


  @override
  Widget build(BuildContext context) {
    List<Widget> uniqueFields = widget.title == "Nutritions"
        ? [
      _buildTextField(widget.controllers[0], 'What did you eat today for breakfast?'),
      _buildTextField(widget.controllers[1], 'What did you eat today for lunch?'),
      _buildTextField(widget.controllers[2], 'What did you eat today for dinner?'),
      _buildTextField(widget.controllers[3], 'Did you eat any junk today? If yes, what?'),
      _buildTextField(widget.controllers[4], 'Did you drink 2 litres of water?'),
      _buildTextField(widget.controllers[5], 'Did you do Warm-up/exercise - 10-15 min?'),
      _buildTextField(widget.controllers[6], 'Juggling - how many?'),
      _buildTextField(widget.controllers[7], 'Sleep - 7-8 hours?'),
    ]
        : widget.title == "Studies"
        ? [
      _buildTextField(widget.controllers[0], 'How much time did you study?'),
      _buildTextField(widget.controllers[1], 'What did you study?'),
      _buildTextField(widget.controllers[2],
          'Did you go to school today? If not, was it a holiday?'),
    ]
        : widget.title == "Behaviour"
        ? [
      _buildTextField(widget.controllers[0],
          'Did you fight with anyone? If yes, did you resolve it?'),
      _buildTextField(widget.controllers[1], 'Did you help someone? If yes, what was it?'),
      _buildTextField(widget.controllers[2], 'Did you lie today? If yes, what was it?'),
      _buildTextField(widget.controllers[3],
          'Did you use foul language? If yes, did you say sorry and solve it?'),
      _buildTextField(widget.controllers[4],
          'Did you smoke/drink/use any drugs? (Call Jesson Sir if needed)'),
    ]
        : widget.title == "Self Control"
        ? [
      _buildTextField(widget.controllers[0],
          'Did you disobey parents/teachers? If yes, what was it?'),
      _buildTextField(widget.controllers[1],
          'Did you tell a new person about SMI? If yes, to whom?'),
      _buildTextField(widget.controllers[2],
          'Did you invite a new student for SMI games? If yes, when will he join?'),
      _buildTextField(widget.controllers[3],
          'Did you save some money in your piggy bank? If yes, how much?'),

    ]

        : [
      _buildTextField(widget.controllers[0],
          'Did you help your parents today? If yes, what was it?'),
    ]
    ;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: hasError
            ? BorderSide(color: Colors.red, width: 2)
            : BorderSide.none,
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            leading: Icon(widget.icon),
            title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: widget.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(children: uniqueFields),
              ),
            ),
            crossFadeState:
            isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field cannot be empty';
          } else {
            // setState(() => hasError = false);
            return null;
          }
        },
      ),
    );
  }
}