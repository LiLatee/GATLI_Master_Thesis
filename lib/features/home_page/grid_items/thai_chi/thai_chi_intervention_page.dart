import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_intervention_cubit.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_page.dart';

class ThaiChiInterventionPage extends StatefulWidget {
  const ThaiChiInterventionPage({Key? key}) : super(key: key);

  static const routeName = '/thaiChiIntervention';

  @override
  State<ThaiChiInterventionPage> createState() =>
      _ThaiChiInterventionPageState();
}

class _ThaiChiInterventionPageState extends State<ThaiChiInterventionPage> {
  late final ThaiChiInterventionCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = ThaiChiInterventionCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thai Chi Intervention'),
      ),
      body: BlocBuilder(
        bloc: _cubit,
        builder: (context, state) {
          if (state is ThaiChiInterventionStateLoaded) {
            return _buildLoaded(state);
          } else if (state is ThaiChiInterventionStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text('Error :/'),
            );
          }
        },
      ),
    );
  }

  ListView _buildLoaded(ThaiChiInterventionStateLoaded state) {
    return ListView.builder(
      itemCount: state.lessons.length,
      itemBuilder: (context, index) {
        final lesson = state.lessons[index];
        return Card(
          child: ListTile(
              title: Text(lesson.title),
              trailing: lesson.isPerformed
                  ? Icon(
                      Icons.check_box,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              leading: Image.network(
                  'https://img.youtube.com/vi/${lesson.ytVideoId}/mqdefault.jpg'),
              onTap: () => Navigator.pushNamed(
                    context,
                    ThaiChiPage.routeName,
                    arguments: ThaiChiPageArguments(
                      thaiChiLesson: state.lessons[index],
                      thaiChiIntervention: state.thaiChiIntervention,
                    ),
                  )),
        );
      },
    );
  }
}
