import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_intervention_cubit.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_page.dart';

class TaiChiInterventionPage extends StatefulWidget {
  const TaiChiInterventionPage({Key? key}) : super(key: key);

  static const routeName = '/taiChiIntervention';

  @override
  State<TaiChiInterventionPage> createState() => _TaiChiInterventionPageState();
}

class _TaiChiInterventionPageState extends State<TaiChiInterventionPage> {
  late final TaiChiInterventionCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = TaiChiInterventionCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tai Chi Intervention'),
      ),
      body: BlocBuilder(
        bloc: _cubit,
        builder: (context, state) {
          if (state is TaiChiInterventionStateLoaded) {
            return _buildLoaded(state);
          } else if (state is TaiChiInterventionStateLoading) {
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

  Widget _buildLoaded(TaiChiInterventionStateLoaded state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Hi!',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Here are recommended Tai Chi lessons for you. You have freedom in choosing the order of lessons. 😊',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
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
                          TaiChiPage.routeName,
                          arguments: TaiChiPageArguments(
                            taiChiLesson: state.lessons[index],
                            taiChiIntervention: state.taiChiIntervention,
                          ),
                        )),
              );
            },
          ),
        ),
      ],
    );
  }
}
