import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawpredict/services/global.dart';
import 'package:pawpredict/utils/appbar.dart';
import 'package:pawpredict/utils/navbar.dart';


class DogInformation extends StatefulWidget {
  const DogInformation({super.key});

  @override
  State<DogInformation> createState() => _DogInformationState();
}

class _DogInformationState extends State<DogInformation> {

  // TextEditingController _dogAge = TextEditingController();
  double currentValue = 1.0;

  String? selectedBreed;
  String? selectedAge;

  List<String> dogBreedList = ['Shih Tzu', 'Pomeranian', 'Aspin'];
  List<String> dogAgeList = ['Puppy (Below 2 years old)', 'Adult (2-7 years old)', 'Senior (8+ years old)' ];

  int _selectedGender = 0;


  // void _onSliderChanged(double value) {
  //   setState(() {
  //     currentValue = value;
  //     _dogAge.text = value.toStringAsFixed(0);
  //   });
  // }

  // void _onTextChanged(String value) {
  //   double newValue = double.tryParse(value) ?? 0.0;
  //   if (newValue >= 1.0 && newValue <= 20.0) {
  //     setState(() {
  //       currentValue = newValue;
  //     });
  //   } else if (newValue <= 1.0){
  //     setState(() {
  //       currentValue = 1.0;
  //     });
  //   } else if (newValue >= 20.0){
  //     setState(() {
  //       currentValue = 20.0;
  //       _dogAge.text = '20';
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    setState(() {
      currentPage = 'Dog Information';
      currentPageTitle = 'Dog Information';
    });

    // _dogAge.text = '1';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Navbar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1DCFC1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Appbar(),
            ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    children: [

                      Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFCAFFFB),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Text(
                          'Want to know more about your dog\'s health? Input your dog\'s details for personalized insights and accurate health predictions.',
                          style: TextStyle(
                            color: Color(0xFF344C9E),
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),



                      Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: buildText(text: 'Name')
                            ),

                            SizedBox(height: 5.0),

                            buildTextField(
                                hintText: '(Optional) Ex. Bantatay',
                                onChanged: (value) {  }
                            ),
                          ],
                        ),
                      ),


                      SizedBox(height: 10),

                      Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                buildText(text: 'Breed'),
                                SizedBox(width: 5),
                                Text(
                                  '(Required)',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 10
                                  ),
                                ),
                              ],
                            ),


                            SizedBox(height: 5.0),

                            buildDropdownField(
                              hintText: 'Select an option',
                              items: dogBreedList,
                              selectedValue: selectedBreed,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedBreed = newValue;
                                });
                              },
                            ),
                          ],
                        ),
                      ),




                      SizedBox(height: 10),

                      Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                buildText(text: 'Gender'),
                                SizedBox(width: 5),
                                Text(
                                  '(Required)',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 10
                                  ),
                                ),
                              ],
                            ),


                            SizedBox(height: 5.0),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                buildRadio(
                                  title: "Male",
                                  value: 1,
                                  groupValue: _selectedGender,
                                  onChanged: (int newValue) {
                                    setState(() {
                                      _selectedGender = newValue;
                                    });
                                  },
                                ),
                                SizedBox(width: 10),
                                buildRadio(
                                  title: "Female",
                                  value: 2,
                                  groupValue: _selectedGender,
                                  onChanged: (int newValue) {
                                    setState(() {
                                      _selectedGender = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),


                      SizedBox(height: 10),

                      Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                buildText(text: 'Age'),
                                SizedBox(width: 5),
                                Text(
                                  '(Required)',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 10
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),

                            buildDropdownField(
                              hintText: 'Select an age',
                              items: dogAgeList,
                              selectedValue: selectedAge,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedAge = newValue;
                                });
                              },
                            ),
                          ],
                        ),
                      ),




                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: (_selectedGender != 0 && selectedBreed != null && selectedAge != null)
                          ? Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 50),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context, '/dog-symptoms1');
                                  },
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1DCFC1),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        width: 3,
                                        color: Color(0xFF1DCFC1),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Next',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          )
                          : SizedBox()
                        ),



                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildText({
    required String text,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xFF091F5C),
        fontFamily:'Lexend',
        fontWeight: FontWeight.w700,
        fontSize: 20.0,
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    TextEditingController? controller,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      style: TextStyle(
        color: Color(0xFF1E1E1E),
        fontFamily:'Lexend',
        fontWeight: FontWeight.w400,
        fontSize: 15.0,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0x881E1E1E),
          fontFamily:'Lexend',
          fontWeight: FontWeight.w400,
          fontSize: 15.0,
        ),
        fillColor: Color(0xFFffffff),
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4A6FD7),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Color(0xFF4A6FD7),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField({
    required String hintText,
    required List<String> items,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0x881E1E1E),
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w400,
          fontSize: 15.0,
        ),
        fillColor: Color(0xFFffffff),
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Color(0xFF4A6FD7),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Color(0xFF4A6FD7),
            width: 2,
          ),
        ),
      ),
      dropdownColor: Color(0xFFffffff),
      style: TextStyle(
        color: Color(0xFF1E1E1E),
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w400,
        fontSize: 15.0,
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget buildRadio({
    required String title,
    required int value,
    required int groupValue,
    required ValueChanged<int> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        width: 100,
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: groupValue == value ? Color(0xFF4A6FD7) : Color(0xFFffffff),
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            color: groupValue == value ? Color(0xFF4A6FD7) : Color(0xFF4A6FD7),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Lexend',
              color: groupValue == value ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // Widget buildNumberSlider({
  //   required double currentValue,
  //   required ValueChanged<double> onChanged,
  // }) {
  //   return Row(
  //     children: [
  //       Container(
  //         width: 60,
  //         child: buildTextField(
  //           hintText: '0',
  //           numberOnly: true,
  //           controller: _dogAge,
  //           onChanged: _onTextChanged,
  //         ),
  //       ),
  //       Expanded(
  //         child: Slider(
  //           value: currentValue,
  //           min: 1,
  //           max: 20,
  //           divisions: 20,
  //           label: currentValue.round().toString(),
  //           onChanged: onChanged,
  //           activeColor: Color(0xFF4A6FD7),
  //           inactiveColor: Color(0xFFB0C4DE),
  //         ),
  //       ),
  //     ],
  //   );
  // }


}


