import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../shared/models/member_model.dart';

class MembershipCardService {
  Future<Uint8List> generateCardPdf(
    MemberModel member,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat:
            PdfPageFormat.a4,

        build: (context) {
          return pw.Center(
            child: pw.Container(
              width: 350,

              padding:
                  const pw.EdgeInsets.all(
                20,
              ),

              decoration:
                  pw.BoxDecoration(
                border:
                    pw.Border.all(),
              ),

              child: pw.Column(
                children: [

                  pw.Text(
                    'ILCKL',
                    style:
                        pw.TextStyle(
                      fontSize: 24,
                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),

                  pw.Text(
                    'Membership Card',
                  ),

                  pw.SizedBox(
                    height: 20,
                  ),

                  pw.Text(
                    member.fullName,
                    style:
                        pw.TextStyle(
                      fontSize: 18,
                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(
                    height: 20,
                  ),

                  _row(
                    'Membership No',
                    member.membershipNo ??
                        'Pending',
                  ),

                  _row(
                    'IC Number',
                    member.icNumber ??
                        '-',
                  ),

                  _row(
                    'Membership Type',
                    member.membershipType ??
                        'Ahli Biasa',
                  ),

                  _row(
                    'Status',
                    member
                        .membershipStatus,
                  ),

                  _row(
                    'Expiry Date',
                    member.expiryDate
                            ?.toString()
                            .split(' ')
                            .first ??
                        '-',
                  ),

                  pw.SizedBox(
                    height: 25,
                  ),

                  pw.BarcodeWidget(
                    barcode:
                        pw.Barcode.qrCode(),

                    data:
                        member.qrData,

                    width: 140,
                    height: 140,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _row(
    String label,
    String value,
  ) {
    return pw.Padding(
      padding:
          const pw.EdgeInsets.symmetric(
        vertical: 4,
      ),

      child: pw.Row(
        mainAxisAlignment:
            pw.MainAxisAlignment
                .spaceBetween,

        children: [
          pw.Text(label),
          pw.Text(value),
        ],
      ),
    );
  }

  Future<void> printCard(
    MemberModel member,
  ) async {
    await Printing.layoutPdf(
      onLayout: (_) =>
          generateCardPdf(
        member,
      ),
    );
  }
}