import 'package:airotrack_courier/utils/app_colors.dart';
import 'package:airotrack_courier/utils/width_height.dart';
import 'package:airotrack_courier/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading:customBackButton(context),
        backgroundColor: AppColors.primaryBlue,
        title: Text("Contact Us", style: TextStyle(color: AppColors.white,fontWeight:FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Text("Address",style:TextStyle(fontWeight:FontWeight.w500,fontSize:20)),
          height10,
          Row(
            children: [
              Icon(Icons.location_on_outlined,color:AppColors.primaryBlue,),
              Text("Kochi,Kerala")
            ],
          ),
          Divider(),
          Text("Email us at",style:TextStyle(fontSize:20,fontWeight:FontWeight.w500),),
          height5,
          Text("customercare@gmail.com"),
          height15,
          Text("Call us at",style:TextStyle(fontSize:20,fontWeight:FontWeight.w500)),
          height5,
          Text("+91 1234567890")

        ],
      ),
      ),
    );
  }
}
