import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tukangku/blocs/payment_bloc/payment_bloc.dart';
import 'package:tukangku/models/payment_model.dart';
import 'package:tukangku/screens/widgets/bottom_sheet_modal.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';
import 'package:tukangku/utils/currency_format.dart';
import 'package:tukangku/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class MasterPaymentDetail extends StatefulWidget {
  final PaymentModel paymentModel;
  const MasterPaymentDetail({Key? key, required this.paymentModel})
      : super(key: key);

  @override
  _MasterPaymentDetailState createState() => _MasterPaymentDetailState();
}

class _MasterPaymentDetailState extends State<MasterPaymentDetail> {
  late PaymentBloc paymentBloc;

  Future confirmPayment() async {
    BottomSheetModal.show(context, children: [
      const Text('Apakah kamu yakin ingin mengkonfirmasi?'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(primary: Colors.orangeAccent.shade700),
            child:
                const Text('Konfirmasi', style: TextStyle(color: Colors.white)),
            onPressed: () {
              paymentBloc.add(ConfirmPayment(widget.paymentModel.id!));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ]);
  }

  Future cancelPayment() async {
    BottomSheetModal.show(context, children: [
      const Text('Apakah kamu yakin ingin membatalkan?'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(primary: Colors.orangeAccent.shade700),
            child:
                const Text('Batalkan', style: TextStyle(color: Colors.white)),
            onPressed: () {
              paymentBloc.add(CancelPayment(widget.paymentModel.id!));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ]);
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  void initState() {
    paymentBloc = BlocProvider.of<PaymentBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is ConfirmPaymentSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is ConfirmPaymentError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        } else if (state is CancelPaymentSuccess) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.success);
          Navigator.pop(context);
        } else if (state is CancelPaymentError) {
          CustomSnackbar.showSnackbar(
              context, state.message, SnackbarType.error);
        }
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Detail Transaksi Pembeli',
                style: TextStyle(color: Colors.black87),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  ))),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3,
                                offset: Offset(0, 1))
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data Pembayaran',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Kode Pembayaran')),
                              Text(widget.paymentModel.paymentCode ?? '')
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Invoice')),
                              Text(widget.paymentModel.transactionModel!
                                      .invoiceId ??
                                  '')
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Tanggal')),
                              Text(widget.paymentModel.createdAt ?? '')
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Tipe bayar')),
                              Text(widget.paymentModel.type ?? '')
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Tipe transfer')),
                              Text(widget.paymentModel.typeTransfer ?? '')
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('No Rek')),
                              Text(widget.paymentModel.bankNumber ?? '')
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Nama Rek')),
                              Text(widget.paymentModel.bankName ?? '')
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Nominal')),
                              Text(currencyId
                                  .format(widget.paymentModel.totalPayment)
                                  .toString())
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Status')),
                              Text(widget.paymentModel.status!.toUpperCase())
                            ],
                          ),

                          GestureDetector(
                            onTap: () => _launchURL(
                                widget.paymentModel.imagesPayment ??
                                    'https://i.pravatar.cc/300'),
                            child: Container(
                              width: size.width,
                              height: size.width,
                              child: CustomCachedImage.build(context,
                                  imgUrl: widget.paymentModel.imagesPayment ??
                                      'https://i.pravatar.cc/300'),
                            ),
                          ),

                          Divider(
                            thickness: 0.4,
                          ),
                          Text(
                            'Data User',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Nama')),
                              Text(widget.paymentModel.user!.name ?? '')
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Latitude')),
                              Text(widget.paymentModel.latitude ?? '')
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Longitude')),
                              Text(widget.paymentModel.longitude ?? '')
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Lokasi')),
                              GestureDetector(
                                onTap: () => _launchURL(
                                    'http://maps.google.com/maps?q=${widget.paymentModel.latitude},${widget.paymentModel.longitude}'),
                                child: Text(
                                  'Lihat',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                            ],
                          ),

                          GestureDetector(
                            onTap: () => _launchURL(
                                widget.paymentModel.imagesUser ??
                                    'https://i.pravatar.cc/300'),
                            child: Container(
                              width: size.width,
                              height: size.width,
                              child: CustomCachedImage.build(context,
                                  imgUrl: widget.paymentModel.imagesUser ??
                                      'https://i.pravatar.cc/300'),
                            ),
                          ),

                          Divider(
                            thickness: 0.4,
                          ),
                          Text('Alamat'),
                          Text(widget.paymentModel.address ?? ''),
                          Divider(
                            thickness: 0.4,
                          ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //         child: Text(
                          //       'Total',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     )),
                          //     Text(
                          //       'Rp 230.000',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     )
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    widget.paymentModel.status != 'success' &&
                            widget.paymentModel.status != 'reject'
                        ? Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.red.shade600),
                                  onPressed: () => cancelPayment(),
                                  child: Text('Batalkan',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.green.shade600),
                                  onPressed: () => confirmPayment(),
                                  child: Text('Konfirmasi',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
              BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, state) {
                  if (state is ConfirmPaymentLoading ||
                      state is CancelPaymentLoading) {
                    return Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Center(
                          child: Container(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                color: Colors.orangeAccent.shade700,
                                strokeWidth: 3,
                              )),
                        ));
                  } else {
                    return Container();
                  }
                },
              )
            ],
          )),
    );
  }
}
