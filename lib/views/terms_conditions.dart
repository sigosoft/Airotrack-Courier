import 'package:airotrack_courier/widgets/custom_back_button.dart';
import 'package:airotrack_courier/widgets/custom_build_section.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: customBackButton(context),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSection(
              'Account Terms',
              'Cupidatat irure theas Laborum magna nulla duis ullamco cillum dolor. Sed ut perspicviatis unde omnis iste natus error sit voluptatem accusantium doloremque',
            ),
            const SizedBox(height: 25),
            buildSection(
              'Copyright and Licenses',
              'Cupidatat irure theas Laborum magna nulla duis ullamco cillum dolor. Sed ut perspicviatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illoamet inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, quiamet dolorem ipsum quia dolor sit amet, cons tbsa, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrumamet exercitationem ullam corporis suscipitamet laboriosam, nisi ut aliquid ex ea commodi consequatur?',
            ),
          ],
        ),
      ),
    );
  }



  
}