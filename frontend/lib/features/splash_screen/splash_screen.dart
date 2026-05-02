import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';

class SplashScreen extends StatefulWidget {
	const SplashScreen({super.key});

	@override
	State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
		with SingleTickerProviderStateMixin {
	late final AnimationController _controller;
	late final Animation<double> _fadeIn;
	late final Animation<double> _logoScale;
	late final Animation<Offset> _titleSlide;
	Timer? _timer;

	@override
	void initState() {
		super.initState();
		_controller = AnimationController(
			vsync: this,
			duration: const Duration(milliseconds: 1600),
		);

		_fadeIn = CurvedAnimation(
			parent: _controller,
			curve: const Interval(0.1, 0.8, curve: Curves.easeOut),
		);

		_logoScale = Tween<double>(begin: 0.86, end: 1).animate(
			CurvedAnimation(
				parent: _controller,
				curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
			),
		);

		_titleSlide = Tween<Offset>(
			begin: const Offset(0, 0.2),
			end: Offset.zero,
		).animate(
			CurvedAnimation(
				parent: _controller,
				curve: const Interval(0.25, 1.0, curve: Curves.easeOutCubic),
			),
		);

		_controller.forward();

		_timer = Timer(const Duration(milliseconds: 2500), () {
			if (!mounted) {
				return;
			}
			context.goNamed(RouteName.loginName);
		});
	}

	@override
	void dispose() {
		_timer?.cancel();
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		const brandGreen = Color(0xFF3D9970);
		const deepGreen = Color(0xFF2D7A5C);

		return Scaffold(
			body: Container(
				decoration: const BoxDecoration(
					gradient: LinearGradient(
						begin: Alignment.topLeft,
						end: Alignment.bottomRight,
						colors: [
							Color(0xFFF3FBF7),
							Color(0xFFE8F6EF),
							Color(0xFFDFF2E9),
						],
					),
				),
				child: Stack(
					children: [
						const _BackgroundShapes(),
						Center(
							child: FadeTransition(
								opacity: _fadeIn,
								child: Column(
									mainAxisSize: MainAxisSize.min,
									children: [
										ScaleTransition(
											scale: _logoScale,
											child: Container(
												width: 104,
												height: 104,
												decoration: BoxDecoration(
													shape: BoxShape.circle,
													gradient: const LinearGradient(
														colors: [brandGreen, deepGreen],
														begin: Alignment.topLeft,
														end: Alignment.bottomRight,
													),
													boxShadow: [
														BoxShadow(
															color: brandGreen.withValues(alpha: 0.32),
															blurRadius: 28,
															offset: const Offset(0, 14),
														),
													],
												),
												child: const Icon(
													Icons.psychology_alt_rounded,
													color: Colors.white,
													size: 52,
												),
											),
										),
										const SizedBox(height: 24),
										SlideTransition(
											position: _titleSlide,
											child: const Text(
												'Psychora',
												style: TextStyle(
													fontFamily: 'myfont',
													fontSize: 48,
													fontWeight: FontWeight.w700,
													color: Color(0xFF103528),
													letterSpacing: -0.4,
												),
											),
										),
										const SizedBox(height: 8),
										const Text(
											'Care, clarity, and confidence',
											style: TextStyle(
												fontSize: 14,
												fontWeight: FontWeight.w500,
												color: Color(0xFF3B6C58),
												letterSpacing: 0.2,
											),
										),
										const SizedBox(height: 30),
										const SizedBox(
											width: 26,
											height: 26,
											child: CircularProgressIndicator(
												strokeWidth: 2.4,
												valueColor: AlwaysStoppedAnimation(brandGreen),
											),
										),
									],
								),
							),
						),
					],
				),
			),
		);
	}
}

class _BackgroundShapes extends StatefulWidget {
	const _BackgroundShapes();

	@override
	State<_BackgroundShapes> createState() => _BackgroundShapesState();
}

class _BackgroundShapesState extends State<_BackgroundShapes>
		with SingleTickerProviderStateMixin {
	late final AnimationController _pulse;

	@override
	void initState() {
		super.initState();
		_pulse = AnimationController(
			vsync: this,
			duration: const Duration(seconds: 4),
		)..repeat(reverse: true);
	}

	@override
	void dispose() {
		_pulse.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return AnimatedBuilder(
			animation: _pulse,
			builder: (context, child) {
				final drift = math.sin(_pulse.value * math.pi * 2) * 10;

				return Stack(
					children: [
						Positioned(
							top: -58 + drift,
							right: -40,
							child: Container(
								width: 200,
								height: 200,
								decoration: BoxDecoration(
									shape: BoxShape.circle,
									color: const Color(0xFF3D9970).withValues(alpha: 0.12),
								),
							),
						),
						Positioned(
							bottom: -72 - drift,
							left: -30,
							child: Container(
								width: 230,
								height: 230,
								decoration: BoxDecoration(
									shape: BoxShape.circle,
									color: const Color(0xFF2D7A5C).withValues(alpha: 0.08),
								),
							),
						),
					],
				);
			},
		);
	}
}
