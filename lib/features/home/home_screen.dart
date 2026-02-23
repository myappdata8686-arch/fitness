import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Welcome back, Alex',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            const _InfoCard(
              title: 'Current Phase',
              value: 'Foundation Build - Week 2',
              description:
                  'Purpose: Rebuild consistency through small daily wins in body, mind, and spirit.',
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              title: 'Weekly Integrity',
              value: '82%',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Mini Stats',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatChip(label: 'Green', value: '4'),
                        _StatChip(label: 'Yellow', value: '2'),
                        _StatChip(label: 'Red', value: '1'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              title: 'Walk Progress',
              value: '14,200 / 20,000 steps',
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              title: 'Strength Progress',
              value: '3 / 4 sessions completed',
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              title: 'Credits',
              value: '126',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Enter Today'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    this.description,
  });

  final String title;
  final String value;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
