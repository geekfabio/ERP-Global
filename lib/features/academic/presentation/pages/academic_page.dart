import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../widgets/assignment_tab.dart';
import '../widgets/classroom_tabs.dart';
import '../widgets/curriculum_tab.dart';
import '../widgets/structure_tabs.dart';
import '../widgets/teacher_tab.dart';

/// Académico: ciclos, classes, cursos, disciplinas, currículo, salas, turnos, turmas e professores.
class AcademicPage extends StatelessWidget {
  const AcademicPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 10,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Text(
                  'Académico',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: 'Ciclos'),
                  Tab(text: 'Classes'),
                  Tab(text: 'Cursos'),
                  Tab(text: 'Disciplinas'),
                  Tab(text: 'Currículo'),
                  Tab(text: 'Salas'),
                  Tab(text: 'Turnos'),
                  Tab(text: 'Turmas'),
                  Tab(text: 'Professores'),
                  Tab(text: 'Atribuições'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    LevelsTab(),
                    GradesTab(),
                    CoursesTab(),
                    SubjectsTab(),
                    CurriculumTab(),
                    RoomsTab(),
                    ShiftsTab(),
                    ClassroomsTab(),
                    TeachersTab(),
                    AssignmentsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
