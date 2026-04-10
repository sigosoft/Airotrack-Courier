import 'package:airotrack_courier/utils/app_colors.dart';
import 'package:airotrack_courier/widgets/custom_back_button.dart';
import 'package:airotrack_courier/widgets/custom_build_section.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: customBackButton(context),
        title: Text(
          "Privacy Policy",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSection(
              'Privacy Policy',
              'Cupidatat irure theas Laborum magna nulla duis ullamco cillum dolor. Sed ut perspicviatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illoamet inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, quiamet dolorem ipsum quia dolor sit amet, cons tbsa, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrumamet exercitationem ullam corporis suscipitamet laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iuametre reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur',
            ),
          ],
        ),
      ),
    );
  }
}
