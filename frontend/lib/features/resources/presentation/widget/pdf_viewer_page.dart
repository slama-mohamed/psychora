import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

import '../function/diagnostic_resource.dart';

class PdfViewerPage extends StatefulWidget {
  final DiagnosticResource resource;

  const PdfViewerPage({
    super.key,
    required this.resource,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? _localPath;
  bool _isLoading = true;
  String? _error;

  int _currentPage = 0;
  int _totalPages = 0;

  PDFViewController? _pdfController;

  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final bytes =
          await rootBundle.load(widget.resource.assetPath);

      final dir = await getTemporaryDirectory();

      final file = File(
        '${dir.path}/${widget.resource.assetPath.split('/').last}',
      );

      await file.writeAsBytes(
        bytes.buffer.asUint8List(),
        flush: true,
      );

      setState(() {
        _localPath = file.path;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Unable to load the PDF\n$e';
        _isLoading = false;
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          else if (_error != null)
            Center(
              child: Text(
                _error!,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          else
            PDFView(
              filePath: _localPath!,

              /// 🔹 Défilement horizontal
              enableSwipe: true,
              swipeHorizontal: true,

              /// 🔹 Une page par écran
              pageSnap: true,
              pageFling: true,

              /// 🔹 espace minimal
              autoSpacing: true,

              fitPolicy: FitPolicy.BOTH,

              backgroundColor: Colors.black,

              onRender: (pages) {
                setState(() {
                  _totalPages = pages ?? 0;
                });
              },

              onViewCreated: (controller) {
                _pdfController = controller;
              },

              onPageChanged: (page, total) {
                setState(() {
                  _currentPage = page ?? 0;
                  _totalPages = total ?? 0;
                });
              },
            ),

          /// zone transparente pour capter le clic
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _toggleControls,
            ),
          ),

          /// BARRE HAUT
          if (_showControls)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Text(
                          widget.resource.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          /// BARRE BAS
          if (_showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        onPressed: _currentPage > 0
                            ? () {
                                _pdfController?.setPage(
                                    _currentPage - 1);
                              }
                            : null,
                      ),
                      Text(
                        'Page ${_currentPage + 1} / $_totalPages',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                        onPressed:
                            _currentPage < _totalPages - 1
                                ? () {
                                    _pdfController?.setPage(
                                        _currentPage + 1);
                                  }
                                : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}