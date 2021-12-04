import 'package:flutter/material.dart';
import 'package:tukangku/models/payment_model.dart';
import 'package:tukangku/screens/widgets/custom_cached_image.dart';
import 'package:tukangku/utils/currency_format.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDetail extends StatefulWidget {
  final PaymentModel paymentModel;
  const PaymentDetail({ Key? key, required this.paymentModel }) : super(key: key);

  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
      
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Payment Detail - ${widget.paymentModel.paymentCode}}',
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 0.5,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.grey.shade100,
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
                          Divider(),
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

                          SizedBox(
                            height: 15,
                          ),
                          widget.paymentModel.imagesPayment != null && widget.paymentModel.imagesPayment != '' ? GestureDetector(
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
                          ) : Container(),

                          Divider(
                            thickness: 0.4,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Data User',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          SizedBox(
                            height: 15,
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
  
                          SizedBox(
                            height: 15,
                          ),
                          widget.paymentModel.imagesUser != null || widget.paymentModel.imagesUser != '' ? GestureDetector(
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
                          ) : Container(),

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
                    
                  ],
                ),
              ),
              
            ],
          )
    );
  }
}