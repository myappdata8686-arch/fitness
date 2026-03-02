import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_data.dart';
import '../common/week_view_screen.dart';

enum DayType { none, red, yellow, green }

class RoutineBlock {
  RoutineBlock({
    required this.id,
    required this.title,
    this.description = 'Editable in Settings',
    this.isCompleted = false,
    this.expandable = false,
  });

  final String id;
  final String title;
  String description;
  bool isCompleted;
  final bool expandable;
}

class PhysicalScreen extends StatefulWidget {
  const PhysicalScreen({super.key, this.autoOpenCheckIn = false});

  final bool autoOpenCheckIn;

  @override
  State<PhysicalScreen> createState() => _PhysicalScreenState();
}

class _PhysicalScreenState extends State<PhysicalScreen> {
  DayType evaluatedDay = DayType.none;
  DayType confirmedDay = DayType.none;

  int currentPhase = 0;

  // Unlock flags (journey-integrated later).
  bool calorieUnlocked = false;
  bool macroUnlocked = false;
  bool foodFeelUnlocked = false;
  bool defenceModeActive = false;
  bool bodybuildingModeActive = false;

  int pain = 3;
  int sleep = 3;
  int energy = 3;
  int stress = 3;

  bool vertigo = false;
  bool travelBusy = false;

  int junkCount = 0;
  double waterLiters = 0.0;
  List<Map<String, dynamic>> meals = [];

  final TextEditingController _waterController = TextEditingController();


  bool _didAutoOpen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didAutoOpen && widget.autoOpenCheckIn) {
      _didAutoOpen = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _openCheckInModal());
    }
  }
  @override
  void dispose() {
    _waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              final app = context.read<AppData>();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => WeekViewScreen(app: app, onOpenDate: (_) {})));
            },
          ),
          title: const Text('Physical'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Ritual'),
              Tab(text: 'Health'),
              Tab(text: 'Body'),
              Tab(text: 'Trends'),
              Tab(text: 'Journey'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRitualTab(),
            const _SimplePlaceholder(text: 'Coming soon.'),
            const _SimplePlaceholder(text: 'Coming soon.'),
            const _SimplePlaceholder(text: 'Coming soon.'),
            const _SimplePlaceholder(text: 'Coming soon.'),
          ],
        ),
      ),
    );
  }

  Widget _buildRitualTab() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(gradient: _ritualGradient(confirmedDay)),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ritual Check-in', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('Evaluated: ${_labelDay(evaluatedDay)}'),
                  Text('Confirmed: ${_labelDay(confirmedDay)}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _openCheckInModal,
                    child: const Text('Run Check-in'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Phase:'),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        value: currentPhase,
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('0 · Recovery')),
                          DropdownMenuItem(value: 1, child: Text('1 · Build')),
                          DropdownMenuItem(value: 2, child: Text('2 · Performance')),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => currentPhase = v);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (confirmedDay == DayType.none)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Complete check-in to generate today\'s ritual.'),
              ),
            )
          else ...[
            _trainingSection(),
            const SizedBox(height: 14),
            _nutritionSection(),
          ],
        ],
      ),
    );
  }

  Widget _trainingSection() {
    final blocks = _buildTrainingBlocks();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Training', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...blocks.map(_routineBlockTile),
          ],
        ),
      ),
    );
  }

  Widget _routineBlockTile(RoutineBlock block) {
    if (!block.expandable) {
      return CheckboxListTile(
        value: block.isCompleted,
        onChanged: (v) {
        final checked = v ?? false;
        setState(() => block.isCompleted = checked);
        final app = context.read<AppData>();
        final rec = app.getOrCreateDailyRecord(DateTime.now());
        rec.ritual.hasTrainingBlock = rec.ritual.hasTrainingBlock || checked;
        app.saveDailyRecord(DateTime.now(), rec);
      },
        title: Text(block.title),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      );
    }

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: CheckboxListTile(
        value: block.isCompleted,
        onChanged: (v) {
        final checked = v ?? false;
        setState(() => block.isCompleted = checked);
        final app = context.read<AppData>();
        final rec = app.getOrCreateDailyRecord(DateTime.now());
        rec.ritual.hasTrainingBlock = rec.ritual.hasTrainingBlock || checked;
        app.saveDailyRecord(DateTime.now(), rec);
      },
        title: Text(block.title),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(block.description),
          ),
        ),
      ],
    );
  }

  List<RoutineBlock> _buildTrainingBlocks() {
    final items = <RoutineBlock>[];

    if (confirmedDay == DayType.red) {
      items.add(_block('rehab_mobility_r', 'Rehab Mobility', expandable: true));
      items.add(_block('gentle_joint_r', 'Gentle Joint Movement (5–10 min)'));
      items.add(_block('sleep_rhythm_r', 'Sleep Rhythm Discipline'));
      if (stress >= 4) {
        items.add(_block('stress_breathing_r', 'Stress Breathing', expandable: true));
      }
      return items;
    }

    if (confirmedDay == DayType.yellow) {
      if (currentPhase == 0) {
        items.add(_block('rehab_mobility_y0', 'Rehab Mobility', expandable: true));
        items.add(_block('light_walk_y0', 'Light Structured Walk'));
        items.add(_block('sleep_rhythm_y0', 'Sleep Rhythm Discipline'));
      } else {
        items.add(_block('stretch_y1', 'Full Body Stretching', expandable: true));
        items.add(_block('walk_y1', '20–30 Minute Walk'));
        items.add(_block('strength_y1', 'Light Bodyweight Strength', expandable: true));
        items.add(_block('recovery_y1', 'Recovery / Power Nap'));
      }
      if (stress >= 4) {
        items.add(_block('stress_reg_y', 'Stress Regulation', expandable: true));
      }
      return items;
    }

    if (currentPhase == 0) {
      items.add(_block('rehab_mobility_g0', 'Rehab Mobility', expandable: true));
      items.add(_block('structured_walk_g0', 'Structured Walk'));
      items.add(_block('sleep_rhythm_g0', 'Sleep Rhythm Discipline'));
    } else {
      items.add(_block('warmup_g1', 'Mobility Warm-up', expandable: true));
      items.add(_block('workout_g1', 'Workout', expandable: true));
      items.add(_block('cooldown_g1', 'Stretching / Cooldown', expandable: true));
      items.add(_block('cardio_g1', 'Cardio / Walk', expandable: true));
    }

    if (stress >= 4) {
      items.add(_block('stress_reg_g', 'Stress Regulation', expandable: true));
    }

    return items;
  }

  RoutineBlock _block(String id, String title, {bool expandable = false}) {
    return RoutineBlock(id: id, title: title, expandable: expandable);
  }

  Widget _nutritionSection() {
    final showCalorieUi = calorieUnlocked && confirmedDay != DayType.red;
    final showMacroUi = macroUnlocked && showCalorieUi;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nutrition', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _openAddMealDialog,
              child: const Text('+ Add Meal'),
            ),
            const SizedBox(height: 8),
            if (meals.isEmpty)
              const Text('No meals logged yet.')
            else
              ...meals.map((m) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${m['type']}: ${m['description']}'),
                    subtitle: _mealSubtitle(m, showMacroUi),
                  )),
            const Divider(height: 22),
            Text('Junk Meals Today: $junkCount'),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => setState(() => junkCount += 1),
                  child: const Text('Add Junk'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => setState(() {
                    if (junkCount > 0) junkCount -= 1;
                  }),
                  child: const Text('Remove Junk'),
                ),
              ],
            ),
            const Divider(height: 22),
            TextField(
              controller: _waterController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Water Intake Today (Liters)'),
              onChanged: (v) => setState(() => waterLiters = double.tryParse(v) ?? 0.0),
            ),
            const SizedBox(height: 6),
            Text('Current Water: ${waterLiters.toStringAsFixed(1)} L'),
            if (showCalorieUi) ...[
              const Divider(height: 22),
              _caloriePanel(showMacroUi: showMacroUi),
            ],
            if (defenceModeActive)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Defence Mode: mild deficit enforced', style: TextStyle(color: Colors.amber)),
              ),
            if (bodybuildingModeActive)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Bodybuilding Mode: macro ratio adjusted automatically', style: TextStyle(color: Colors.lightBlueAccent)),
              ),
          ],
        ),
      ),
    );
  }

  Widget? _mealSubtitle(Map<String, dynamic> meal, bool showMacroUi) {
    if (!calorieUnlocked || meal['calories'] == null) return null;
    if (!showMacroUi) {
      return Text('Calories: ${meal['calories']}');
    }
    return Text(
      'Cal ${meal['calories']} | P ${meal['protein']}g | C ${meal['carbs']}g | F ${meal['fat']}g',
    );
  }

  Widget _caloriePanel({required bool showMacroUi}) {
    final caloriesConsumed = meals.fold<double>(
      0,
      (sum, meal) => sum + ((meal['calories'] as num?)?.toDouble() ?? 0),
    );

    final target = defenceModeActive ? 2000.0 : 2200.0;
    final progress = (caloriesConsumed / target).clamp(0.0, 1.0);

    final proteinConsumed = meals.fold<double>(
      0,
      (sum, meal) => sum + ((meal['protein'] as num?)?.toDouble() ?? 0),
    );
    final carbsConsumed = meals.fold<double>(
      0,
      (sum, meal) => sum + ((meal['carbs'] as num?)?.toDouble() ?? 0),
    );
    final fatConsumed = meals.fold<double>(
      0,
      (sum, meal) => sum + ((meal['fat'] as num?)?.toDouble() ?? 0),
    );

    final proteinTarget = bodybuildingModeActive ? 170.0 : 140.0;
    final carbsTarget = bodybuildingModeActive ? 260.0 : 220.0;
    final fatTarget = bodybuildingModeActive ? 75.0 : 70.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Calories: ${caloriesConsumed.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}'),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 6),
        Text('Remaining calories: ${(target - caloriesConsumed).toStringAsFixed(0)}'),
        if (showMacroUi) ...[
          const SizedBox(height: 10),
          _macroProgress('Protein', proteinConsumed, proteinTarget),
          _macroProgress('Carbs', carbsConsumed, carbsTarget),
          _macroProgress('Fat', fatConsumed, fatTarget),
        ],
      ],
    );
  }

  Widget _macroProgress(String label, double consumed, double target) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ${consumed.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}'),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: (consumed / target).clamp(0.0, 1.0)),
        ],
      ),
    );
  }

  Future<void> _openCheckInModal() async {
    final result = await Navigator.of(context).push<_RitualCheckInResult>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _CheckInModal(
          pain: pain,
          sleep: sleep,
          energy: energy,
          stress: stress,
          vertigo: vertigo,
          travelBusy: travelBusy,
        ),
      ),
    );

    if (result == null) return;

    setState(() {
      pain = result.pain;
      sleep = result.sleep;
      energy = result.energy;
      stress = result.stress;
      vertigo = result.vertigo;
      travelBusy = result.travelBusy;
      evaluatedDay = result.evaluatedDay;
      confirmedDay = result.confirmedDay;
    });

    final app = context.read<AppData>();
    final rec = app.getOrCreateDailyRecord(DateTime.now());
    rec.ritual.dayType = confirmedDay;
    app.saveDailyRecord(DateTime.now(), rec);
  }

  void _openAddMealDialog() {
    String mealType = 'Breakfast';
    final descriptionController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatController = TextEditingController();

    bool bloating = false;
    bool dizziness = false;
    bool lightness = false;
    bool energyStable = false;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Meal'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: mealType,
                    items: const [
                      DropdownMenuItem(value: 'Breakfast', child: Text('Breakfast')),
                      DropdownMenuItem(value: 'Lunch', child: Text('Lunch')),
                      DropdownMenuItem(value: 'Dinner', child: Text('Dinner')),
                      DropdownMenuItem(value: 'Snack', child: Text('Snack')),
                    ],
                    onChanged: (v) => setDialogState(() => mealType = v ?? 'Breakfast'),
                    decoration: const InputDecoration(labelText: 'Meal Type'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  if (calorieUnlocked) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: caloriesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Calories'),
                    ),
                  ],
                  if (macroUnlocked) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: proteinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Protein'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: carbsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Carbs'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: fatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Fat'),
                    ),
                  ],
                  if (foodFeelUnlocked) ...[
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      value: bloating,
                      onChanged: (v) => setDialogState(() => bloating = v ?? false),
                      title: const Text('Bloating'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      value: dizziness,
                      onChanged: (v) => setDialogState(() => dizziness = v ?? false),
                      title: const Text('Dizziness'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      value: lightness,
                      onChanged: (v) => setDialogState(() => lightness = v ?? false),
                      title: const Text('Lightness'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      value: energyStable,
                      onChanged: (v) => setDialogState(() => energyStable = v ?? false),
                      title: const Text('Energy Stable'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    meals.add({
                      'type': mealType,
                      'description': descriptionController.text,
                      if (calorieUnlocked) 'calories': double.tryParse(caloriesController.text) ?? 0,
                      if (macroUnlocked) ...{
                        'protein': double.tryParse(proteinController.text) ?? 0,
                        'carbs': double.tryParse(carbsController.text) ?? 0,
                        'fat': double.tryParse(fatController.text) ?? 0,
                      },
                      if (foodFeelUnlocked)
                        'feel': {
                          'bloating': bloating,
                          'dizziness': dizziness,
                          'lightness': lightness,
                          'energyStable': energyStable,
                        },
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    ).then((_) {
      descriptionController.dispose();
      caloriesController.dispose();
      proteinController.dispose();
      carbsController.dispose();
      fatController.dispose();
    });
  }

  Gradient? _ritualGradient(DayType day) {
    switch (day) {
      case DayType.red:
        return const LinearGradient(colors: [Color(0x55FF5252), Color(0x22121212)]);
      case DayType.yellow:
        return const LinearGradient(colors: [Color(0x55FFC107), Color(0x22121212)]);
      case DayType.green:
        return const LinearGradient(colors: [Color(0x5532CD80), Color(0x22121212)]);
      case DayType.none:
        return null;
    }
  }

  String _labelDay(DayType day) {
    switch (day) {
      case DayType.none:
        return 'None';
      case DayType.red:
        return 'Red';
      case DayType.yellow:
        return 'Yellow';
      case DayType.green:
        return 'Green';
    }
  }
}

class _CheckInModal extends StatefulWidget {
  const _CheckInModal({
    required this.pain,
    required this.sleep,
    required this.energy,
    required this.stress,
    required this.vertigo,
    required this.travelBusy,
  });

  final int pain;
  final int sleep;
  final int energy;
  final int stress;
  final bool vertigo;
  final bool travelBusy;

  @override
  State<_CheckInModal> createState() => _CheckInModalState();
}

class _CheckInModalState extends State<_CheckInModal> {
  late int pain = widget.pain;
  late int sleep = widget.sleep;
  late int energy = widget.energy;
  late int stress = widget.stress;

  late bool vertigo = widget.vertigo;
  late bool travelBusy = widget.travelBusy;

  DayType evaluatedDay = DayType.none;
  DayType? selectedConfirmation;

  @override
  Widget build(BuildContext context) {
    final confirmOptions = _confirmOptions(evaluatedDay);

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Listen to your body.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          _slider('Pain', pain.toDouble(), 1, 10, '$pain ${_painEmoji(pain)}', (v) => setState(() => pain = v.round())),
          _slider('Sleep', sleep.toDouble(), 1, 5, '$sleep ${_sleepEmoji(sleep)}', (v) => setState(() => sleep = v.round())),
          _slider('Energy', energy.toDouble(), 1, 5, '$energy ${_energyEmoji(energy)}', (v) => setState(() => energy = v.round())),
          _slider('Stress', stress.toDouble(), 1, 5, '$stress ${_stressEmoji(stress)}', (v) => setState(() => stress = v.round())),
          const SizedBox(height: 8),
          SwitchListTile(
            value: vertigo,
            onChanged: (v) => setState(() => vertigo = v),
            title: const Text('Vertigo / Dizziness'),
          ),
          SwitchListTile(
            value: travelBusy,
            onChanged: (v) => setState(() => travelBusy = v),
            title: const Text('Travel / Busy'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final e = _evaluate();
              setState(() {
                evaluatedDay = e;
                selectedConfirmation = e;
              });
            },
            child: const Text('Evaluate Day'),
          ),
          if (evaluatedDay != DayType.none) ...[
            const SizedBox(height: 12),
            Text('Evaluated: ${_labelDay(evaluatedDay)}'),
            const SizedBox(height: 8),
            const Text('Select confirmation (upgrade only upward):'),
            ...confirmOptions.map(
              (day) => RadioListTile<DayType>(
                value: day,
                groupValue: selectedConfirmation,
                onChanged: (v) => setState(() => selectedConfirmation = v),
                title: Text(_labelDay(day)),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: selectedConfirmation == null
                  ? null
                  : () {
                      Navigator.pop(
                        context,
                        _RitualCheckInResult(
                          pain: pain,
                          sleep: sleep,
                          energy: energy,
                          stress: stress,
                          vertigo: vertigo,
                          travelBusy: travelBusy,
                          evaluatedDay: evaluatedDay,
                          confirmedDay: selectedConfirmation!,
                        ),
                      );
                    },
              child: const Text('Confirm'),
            ),
          ],
        ],
      ),
    );
  }

  List<DayType> _confirmOptions(DayType evaluated) {
    switch (evaluated) {
      case DayType.red:
        return const [DayType.red, DayType.yellow];
      case DayType.yellow:
        return const [DayType.yellow, DayType.green];
      case DayType.green:
        return const [DayType.green];
      case DayType.none:
        return const [];
    }
  }

  DayType _evaluate() {
    final red = pain >= 7 || sleep <= 2 || energy <= 2 || vertigo;
    if (red) return DayType.red;

    final yellow = (pain >= 4 && pain <= 6) || sleep == 3 || energy == 3 || travelBusy;
    if (yellow) return DayType.yellow;

    return DayType.green;
  }

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    String trailing,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(trailing),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  String _painEmoji(int v) {
    if (v <= 2) return '😌';
    if (v <= 4) return '🙂';
    if (v <= 6) return '😐';
    if (v <= 8) return '😣';
    return '😫';
  }

  String _sleepEmoji(int v) {
    switch (v) {
      case 1:
        return '😫';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      default:
        return '😌';
    }
  }

  String _energyEmoji(int v) {
    switch (v) {
      case 1:
        return '🪫';
      case 2:
        return '😴';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      default:
        return '⚡';
    }
  }

  String _stressEmoji(int v) {
    switch (v) {
      case 1:
        return '😌';
      case 2:
        return '🙂';
      case 3:
        return '😐';
      case 4:
        return '😟';
      default:
        return '😣';
    }
  }

  String _labelDay(DayType day) {
    switch (day) {
      case DayType.none:
        return 'None';
      case DayType.red:
        return 'Red';
      case DayType.yellow:
        return 'Yellow';
      case DayType.green:
        return 'Green';
    }
  }
}

class _RitualCheckInResult {
  const _RitualCheckInResult({
    required this.pain,
    required this.sleep,
    required this.energy,
    required this.stress,
    required this.vertigo,
    required this.travelBusy,
    required this.evaluatedDay,
    required this.confirmedDay,
  });

  final int pain;
  final int sleep;
  final int energy;
  final int stress;
  final bool vertigo;
  final bool travelBusy;
  final DayType evaluatedDay;
  final DayType confirmedDay;
}

class _SimplePlaceholder extends StatelessWidget {
  const _SimplePlaceholder({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}
