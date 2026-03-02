import 'package:flutter/material.dart';

import '../../core/app_data.dart';

class RedeemableReward {
  const RedeemableReward({
    required this.id,
    required this.title,
    required this.costSoft,
    required this.costBig,
    required this.description,
  });

  final String id;
  final String title;
  final int costSoft;
  final int costBig;
  final String description;
}

const List<RedeemableReward> _catalog = [
  RedeemableReward(
    id: 'screen_time',
    title: 'Screen Time',
    costSoft: 2,
    costBig: 1,
    description: 'Private flexible screen-time token for intentional downtime.',
  ),
  RedeemableReward(
    id: 'grooming_upgrade',
    title: 'Grooming Upgrade',
    costSoft: 3,
    costBig: 1,
    description: 'Upgrade a grooming tool or product (beard care / hair product / kit).',
  ),
  RedeemableReward(
    id: 'performance_gear',
    title: 'Performance Gear',
    costSoft: 2,
    costBig: 1,
    description: 'Walking shoes, resistance bands, gym gloves or equivalent.',
  ),
  RedeemableReward(
    id: 'sports_equipment',
    title: 'Sports Equipment',
    costSoft: 2,
    costBig: 1,
    description: 'Simple equipment supporting performance and consistency.',
  ),
  RedeemableReward(
    id: 'personal_upgrade',
    title: 'Personal Upgrade Token',
    costSoft: 99,
    costBig: 1,
    description: 'High-value investment token (photoshoot / arts / social brand asset).',
  ),
];

class RewardCenterScreen extends StatelessWidget {
  const RewardCenterScreen({
    super.key,
    required this.journeyState,
    required this.customRewards,
    required this.onRedeem,
    required this.onWardrobeRedeem,
  });

  final JourneyState journeyState;
  final List<CustomReward> customRewards;
  final bool Function(String rewardId, int costSoft, int costBig) onRedeem;
  final ValueChanged<String> onWardrobeRedeem;

  @override
  Widget build(BuildContext context) {
    final mergedRewards = [
      ..._catalog,
      ...customRewards.map(
        (r) => RedeemableReward(
          id: r.id,
          title: r.title,
          costSoft: r.costType == RewardCostType.soft ? r.cost : 999,
          costBig: r.costType == RewardCostType.big ? r.cost : 999,
          description: r.description,
        ),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CreditSummaryCard(
          softCredits: journeyState.softCredits,
          bigCredits: journeyState.bigCredits,
        ),
        const SizedBox(height: 12),
        RedeemableRewardsGrid(
          rewards: mergedRewards,
          redeemedRewards: journeyState.redeemedRewards,
          softCredits: journeyState.softCredits,
          bigCredits: journeyState.bigCredits,
          onRedeem: onRedeem,
        ),
        if (journeyState.currentPhase >= 4) ...[
          const SizedBox(height: 12),
          WardrobeUnlockSection(
            wardrobeUnlocks: journeyState.wardrobeUnlocks,
            redeemedRewards: journeyState.redeemedRewards,
            onRedeem: onWardrobeRedeem,
          ),
        ],
        const SizedBox(height: 12),
        PhaseMilestoneTimeline(phaseRewards: journeyState.phaseRewards),
      ],
    );
  }
}

class CreditSummaryCard extends StatelessWidget {
  const CreditSummaryCard({
    super.key,
    required this.softCredits,
    required this.bigCredits,
  });

  final int softCredits;
  final int bigCredits;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Soft Credits', style: TextStyle(color: Color(0xFF8BC34A))),
                  Text('$softCredits', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Big Credits', style: TextStyle(color: Color(0xFFFFD54F))),
                  Text('$bigCredits', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RedeemableRewardsGrid extends StatelessWidget {
  const RedeemableRewardsGrid({
    super.key,
    required this.rewards,
    required this.redeemedRewards,
    required this.softCredits,
    required this.bigCredits,
    required this.onRedeem,
  });

  final List<RedeemableReward> rewards;
  final List<String> redeemedRewards;
  final int softCredits;
  final int bigCredits;
  final bool Function(String rewardId, int costSoft, int costBig) onRedeem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Redeemable Rewards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rewards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final reward = rewards[index];
                final redeemed = redeemedRewards.contains(reward.id);
                final canRedeem = !redeemed && (reward.costSoft <= softCredits || reward.costBig <= bigCredits);

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                reward.title,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              iconSize: 18,
                              onPressed: () => _showDescription(context, reward),
                              icon: const Icon(Icons.info_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('${reward.costSoft} Soft or ${reward.costBig} Big', style: const TextStyle(fontSize: 12)),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: canRedeem
                                ? () {
                                    onRedeem(reward.id, reward.costSoft, reward.costBig);
                                  }
                                : null,
                            child: Text(redeemed ? 'Redeemed' : 'Redeem'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDescription(BuildContext context, RedeemableReward reward) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(reward.title),
        content: Text(reward.description),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

class WardrobeUnlockSection extends StatelessWidget {
  const WardrobeUnlockSection({
    super.key,
    required this.wardrobeUnlocks,
    required this.redeemedRewards,
    required this.onRedeem,
  });

  final List<String> wardrobeUnlocks;
  final List<String> redeemedRewards;
  final ValueChanged<String> onRedeem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wardrobe Unlocks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            if (wardrobeUnlocks.isEmpty)
              const Text('No direct mini rewards unlocked yet.')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: wardrobeUnlocks.map((item) {
                  final redeemed = redeemedRewards.contains(item);
                  return OutlinedButton.icon(
                    onPressed: redeemed ? null : () => onRedeem(item),
                    icon: const Icon(Icons.checkroom_outlined),
                    label: Text(redeemed ? '$item · Redeemed' : '$item · Unredeemed'),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class PhaseMilestoneTimeline extends StatelessWidget {
  const PhaseMilestoneTimeline({super.key, required this.phaseRewards});

  final List<PhaseReward> phaseRewards;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Phase Milestones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            ...phaseRewards.map((phase) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phase ${phase.phase}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ...phase.items.map((item) => Text('• $item')),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
