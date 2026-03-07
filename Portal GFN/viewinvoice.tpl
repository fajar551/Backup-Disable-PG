<!DOCTYPE html>
<html lang="en">
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$companyname} - {$pagetitle}</title>

    <link href="{$WEB_ROOT}/templates/{$template}/css/all.min.css" rel="stylesheet">
    <link href="{$WEB_ROOT}/assets/css/fontawesome-all.min.css" rel="stylesheet">
    <link href="{$WEB_ROOT}/templates/{$template}/css/invoice.css" rel="stylesheet">
    
    <link href="templates/{$template}/css/accordion.css" rel="stylesheet">
    <link href="templates/{$template}/css/font-awesome.css" rel="stylesheet">
    <script src="templates/{$template}/js/jquery-3.0.0.min.js"></script>
	<script src="templates/{$template}/js/copytext.js"></script>

</head>
<body>

    <div class="container-fluid invoice-container">

        {if $invalidInvoiceIdRequested}

            {include file="$template/includes/panel.tpl" type="danger" headerTitle=$LANG.error bodyContent=$LANG.invoiceserror bodyTextCenter=true}

        {else}

            <div class="row invoice-header">
                <div class="invoice-col">

                    {if $logo}
                        <p><img src="{$logo}" title="{$companyname}" /></p>
                    {else}
                        <h2>{$companyname}</h2>
                    {/if}
                    <h3>{$pagetitle}</h3>

                </div>
                <div class="invoice-col text-center">

                    <div class="invoice-status">
                        {if $status eq "Draft"}
                            <span class="draft">{$LANG.invoicesdraft}</span>
                        {elseif $status eq "Unpaid"}
                            <span class="unpaid">{$LANG.invoicesunpaid}</span>
                        {elseif $status eq "Paid"}
                            <span class="paid">{$LANG.invoicespaid}</span>
                        {elseif $status eq "Refunded"}
                            <span class="refunded">{$LANG.invoicesrefunded}</span>
                        {elseif $status eq "Cancelled"}
                            <span class="cancelled">{$LANG.invoicescancelled}</span>
                        {elseif $status eq "Collections"}
                            <span class="collections">{$LANG.invoicescollections}</span>
                        {elseif $status eq "Payment Pending"}
                            <span class="paid">{$LANG.invoicesPaymentPending}</span>
                        {/if}
                    </div>

                    {if $status eq "Unpaid" || $status eq "Draft"}
                        <div class="small-text">
                            {$LANG.invoicesdatedue}: {$datedue}
                        </div>
                        <div class="payment-btn-container hidden-print" align="center">
                            {$paymentbutton}
                        </div>
                    {/if}

                </div>
            </div>

            <hr>

            {if $paymentSuccessAwaitingNotification}
                {include file="$template/includes/panel.tpl" type="success" headerTitle=$LANG.success bodyContent=$LANG.invoicePaymentSuccessAwaitingNotify bodyTextCenter=true}
            {elseif $paymentSuccess}
                {include file="$template/includes/panel.tpl" type="success" headerTitle=$LANG.success bodyContent=$LANG.invoicepaymentsuccessconfirmation bodyTextCenter=true}
            {elseif $pendingReview}
                {include file="$template/includes/panel.tpl" type="info" headerTitle=$LANG.success bodyContent=$LANG.invoicepaymentpendingreview bodyTextCenter=true}
            {elseif $paymentFailed}
                {include file="$template/includes/panel.tpl" type="danger" headerTitle=$LANG.error bodyContent=$LANG.invoicepaymentfailedconfirmation bodyTextCenter=true}
            {elseif $offlineReview}
                {include file="$template/includes/panel.tpl" type="info" headerTitle=$LANG.success bodyContent=$LANG.invoiceofflinepaid bodyTextCenter=true}
            {/if}

            <div class="row">
                <div class="invoice-col right">
                    <strong>{$LANG.invoicespayto}</strong>
                    <address class="small-text">
                        {$payto}
                        {if $taxCode}<br />{$taxIdLabel}: {$taxCode}{/if}
                    </address>
                </div>
                <div class="invoice-col">
                    <strong>{$LANG.invoicesinvoicedto}</strong>
                    <address class="small-text">
                        {if $clientsdetails.companyname}{$clientsdetails.companyname}<br />{/if}
                        {$clientsdetails.firstname} {$clientsdetails.lastname}<br />
                        {$clientsdetails.address1}, {$clientsdetails.address2}<br />
                        {$clientsdetails.city}, {$clientsdetails.state}, {$clientsdetails.postcode}<br />
                        {$clientsdetails.country}
                        {if $clientsdetails.tax_id}
                            <br />{$taxIdLabel}: {$clientsdetails.tax_id}
                        {/if}
                        {if $customfields}
                        <br /><br />
                        {foreach from=$customfields item=customfield}
                        {$customfield.fieldname}: {$customfield.value}<br />
                        {/foreach}
                        {/if}
                    </address>
                </div>
            </div>

            <div class="row">
                <div class="invoice-col right">
                    <strong>{$LANG.paymentmethod}</strong><br>
                    <span class="small-text">
                        {if $status eq "Unpaid" && $allowchangegateway}
                            <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}" class="form-inline">
                                <input name="token" value={$token} type="hidden">
                                    <select name="gateway" onchange="submit()" class="form-control select-inlinenew">
                                    <option value="">{$LANG.choosegateway}</option>
                                    <optgroup label = "Virtual Account">
                                    <option value="bcava">BCA VA</option>
                                    <option value="mandiriva">Mandiri VA</option>
                                    <option value="briva">BRI VA</option>
                                    <option value="bniva">BNI VA</option>
                                    <option value="atmbersamava">ATM Bersama VA</option>
                                    <option value="biiva">BII VA</option>
                                    <option value="cimbva">CIMB VA</option>
                                    <option value="permatabankva">Permata Bank VA</option>
                                    <option value="danamonva">Danamon VA</option>
                                    <option value="hanabankva">Hana Bank VA</option>
                                    <optgroup label = "Bank Transfer">
                                    {banktransfercheck total=$total paymentmethod=$paymentmethod}
                                    <option value="banktransfer">BCA</option>
                                    <option value="banktransfer3">Mandiri</option>
									<option value="banktransfer2">Bank of China (CNY/RMB Only)</option>
                                    <optgroup label = "Credit Card, Alfamart, etc">
                                    <option value="nicepaygateway">Visa / Mastercard Credit Card (Indonesia)</option>
                                    <option value="ipay88_kredivo">Kredivo</option>
                                     <option value="paypal">Paypal (Verified Account only)</option>
                                </select>
                            </form>
                        {else}
                            {$paymentmethod}{if $paymethoddisplayname} ({$paymethoddisplayname}){/if}
                        {/if}
                    </span>
                    <br /><br />
                </div>
                <div class="invoice-col">
                    <strong>{$LANG.invoicesdatecreated}</strong><br>
                    <span class="small-text">
                        {$date}<br><br>
                    </span>
                </div>
            </div>

            <br />

            {if $manualapplycredit}
                <div class="panel panel-success">
                    <div class="panel-heading">
                        <h3 class="panel-title"><strong>{$LANG.invoiceaddcreditapply}</strong></h3>
                    </div>
                    <div class="panel-body">
                        <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}">
                            <input type="hidden" name="applycredit" value="true" />
                            {$LANG.invoiceaddcreditdesc1} <strong>{$totalcredit}</strong>. {$LANG.invoiceaddcreditdesc2}. {$LANG.invoiceaddcreditamount}:
                            <div class="row">
                                <div class="col-xs-8 col-xs-offset-2 col-sm-4 col-sm-offset-4">
                                    <div class="input-group">
                                        <input type="text" name="creditamount" value="{$creditamount}" class="form-control" />
                                        <span class="input-group-btn">
                                            <input type="submit" value="{$LANG.invoiceaddcreditapply}" class="btn btn-success" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            {/if}


            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><strong>{$LANG.invoicelineitems}</strong></h3>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <table class="table table-condensed">
                            <thead>
                                <tr>
                                    <td><strong>{$LANG.invoicesdescription}</strong></td>
                                    <td width="20%" class="text-center"><strong>{$LANG.invoicesamount}</strong></td>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$invoiceitems item=item}
                                    <tr>
                                        <td>{$item.description}{if $item.taxed eq "true"} *{/if}</td>
                                        <td class="text-center">{$item.amount}</td>
                                    </tr>
                                {/foreach}
                                <tr>
                                    <td class="total-row text-right"><strong>{$LANG.invoicessubtotal}</strong></td>
                                    <td class="total-row text-center">{$subtotal}</td>
                                </tr>
                                {if $taxname}
                                    <tr>
                                        <td class="total-row text-right"><strong>{$taxrate}% {$taxname}</strong></td>
                                        <td class="total-row text-center">{$tax}</td>
                                    </tr>
                                {/if}
                                {if $taxname2}
                                    <tr>
                                        <td class="total-row text-right"><strong>{$taxrate2}% {$taxname2}</strong></td>
                                        <td class="total-row text-center">{$tax2}</td>
                                    </tr>
                                {/if}
                                <tr>
                                    <td class="total-row text-right"><strong>{$LANG.invoicescredit}</strong></td>
                                    <td class="total-row text-center">{$credit}</td>
                                </tr>
                                <tr>
                                    <td class="total-row text-right"><strong>{$LANG.invoicestotal}</strong></td>
                                    <td class="total-row text-center">{$total}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            {if $taxrate}
                <p>* {$LANG.invoicestaxindicator}</p>
            {/if}
            <center>
            {invoicedetail invoice=$invoiceid}
{vainvoice va=$InvoicePaymentMethod clientid=$clientsdetails.id}
 {if $InvoicePaymentMethod == 'banktransfer'}
            <p>Mohon Lakukan Pembayaran secara PENUH ke:</p></br>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr class="title textcenter">
                <td align="center"><strong>PT Jejaring Cepat Indonesia</strong></td>
                <td align="center"><strong>No Rekening</strong></td>
            </tr>
            <tr class="title textcenter">
                <td align="center">Bank Central Asia KCP WISMA MULIA</td>
                <td align="center">5035-135-488</td>
            </tr>
            </tbody>
            </table>
             </br>
            <p>*Masukkan INVOICE# {$invoiceid} pada Kolom Berita. Jika Nominal Transfer tidak sesuai dan tidak menggunakan Berita Transfer, Mohon Konfirmasikan Pembayaran Anda ke email <a href="mailto:payment@goldenfast.net"><b>payment@goldenfast.net</b></a><br>Aktivasi pesanan yang pembayarannya menggunakan Bank Transfer hanya dilakukan pada jam kerja Administratif : Senin-Jumat pukul 07.30 – 20.00 WIB, Sabtu – Minggu 07:30 – 18:00 WIB.</p>
            </br>
            {elseif $InvoicePaymentMethod == 'bcaapi'}
            <p>Mohon Lakukan Pembayaran secara PENUH ke:</p></br>
            <div class="table-responsive">
                <table class="table">
            <tbody>
            <tr>
                <td class="total-row"><strong>PT Jejaring Cepat Indonesia</strong></td>
                <td class="total-row"><strong>No Rekening</strong></td>
            </tr>
            <tr>
                <td class="total-row text-left">Bank Central Asia KCP WISMA MULIA</td>
                <td class="total-row">5035-135-488</td>
            </tr>
             </tbody>
            </table>
             </br>
            <p>*Masukkan INVOICE# {$invoiceid} pada Kolom Berita. Jika Nominal Transfer tidak sesuai dan tidak menggunakan Berita Transfer, Mohon Konfirmasikan Pembayaran Anda ke  <a href="https://client.goldenfast.net/submitticket.php?step=2&deptid=2"><b>Support Ticket</b></a><br>Aktivasi pesanan yang pembayarannya menggunakan Bank Transfer hanya dilakukan pada jam kerja Administratif : Senin-Jumat pukul 07.30 – 20.00 WIB, Sabtu – Minggu 07:30 – 18:00 WIB.</p>
            </br>
            {elseif $InvoicePaymentMethod == 'bankbri'}
            <p>Mohon Lakukan Pembayaran secara PENUH ke:</p></br>
            <div class="table-responsive">
                <table class="table">
            <tbody>
            <tr>
                <td class="total-row"><strong>PT Jejaring Cepat Indonesia</strong></td>
                <td class="total-row"><strong>No Rekening</strong></td>
            </tr>
            <tr>
                    <td class="total-row text-left">Bank BRI KC Martadinata Bandung</td>
                    <td class="total-row">0389-01-000714-30-8</td>  
            </tr>
             </tbody>
            </table>
            
            {elseif $InvoicePaymentMethod == 'nicepaygatewayva'}
            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Klik Bayar Sekarang</li>
                    <li>Pilih Bank yang diinginkan</li>
                    <li>Generate Nomor Virtual account</li>
                    <li>Selesaikan pembayaran sesuai Intruksi yang tertera</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'nicepaygateway'}
            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Isi data lengkap pada halaman yang tertera</li>
                    <li>Klik Process</li>
                    <li>Lakukan Verifikasi 3DSecure</li>
                    <li>Selesaikan pembayaran</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'dokuwallet'}
            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Klik Bayar Sekarang</li>
                    <li>Login Akun Doku dan Isi data lengkap pada halaman yang tertera</li>
                    <li>Klik Process Payment</li>
                    <li>Selesaikan pembayaran</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'alfamart'}
            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table">
            <tbody>
            <tr>
                <td class="total-row">
                   <ol>
                    <li>Klik Bayar Sekarang</li>
                    <li>Isi data lengkap pada halaman yang tertera</li>
                    <li>Klik Process Payment</li>
                    <li>Catat No DOKU/No Pembayaran yang muncul</li>
                    <li>Kunjungi Alfamart Terdekat</li>
                    <li>Informasikan No DOKU/No Pembayaran ke kasir untuk pembayaran DOKU</li>
                    <li>Selesaikan pembayaran</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'bcaklikpay'}
            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table">
            <tbody>
            <tr>
                <td class="total-row">
                   <ol>
                    <li>Klik Bayar Sekarang</li>
                    <li>Klik Order</li>
                    <li>Login ke akun BCA Klikpay Anda</li>
                    <li>Pilihlah jenis pembayaran KlikBCA atau BCA Card untuk transaksi tersebut.</li>
                    <li>Untuk otorisasi pembayaran dengan BCA KlikPay, tekan tombol 'kirim OTP', Anda akan menerima kode OTP (One Time Password) melalui SMS. Masukkan kode OTP tersebut pada kolom yang tersedia.</li>
                    <li>Apabila kode OTP yang Anda masukkan benar, transaksi pembayaran akan langsung diproses dan saldo rekening Anda (untuk jenis pembayaran KlikBCA) atau limit BCA Card Anda (untuk jenis pembayaran BCA Card) akan berkurang sejumlah nilai transaksi.</li>
                    <li>Status keberhasilan transaksi Anda akan tampil pada layar transaksi dan Anda akan menerima email notifikasi.</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'ipay88_kredivo'}
            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table">
            <tbody>
            <tr>
                <td class="total-row">
                   <ol>
                    <li>Klik Proceed Payment/Bayar Sekarang</li>
                    <li>Klik Proceed</li>
                    <li>Pilih Metode Cicilan dan Login Akun Kredivo anda</li>
                    <li>Selesaikan pembayaran</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'paypal'}
            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table">
            <tbody>
            <tr>
                <td class="total-row">
                  <ol>
                    <li>Klik Paypal Checkout</li>
                    <li>Login Akun Paypal anda</li>
                    <li>Selesaikan pembayaran</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'banktransfer3'}
            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr class="title textcenter">
                <td class="total-row"><strong>PT Jejaring Cepat Indonesia</strong></td>
                <td class="total-row"><strong>No Rekening</strong></td>
            </tr>
            <tr class="title textcenter">
                <td class="total-row text-left">Bank Mandiri KCP WISMA MULIA Jakarta</td>
                <td class="total-row">07-000-1-222-1-888</td>  
            </tr> 
             </tbody>
            </table>
            </br>
            <p>*Masukkan INVOICE[SPASI]{$invoiceid} atau INV[SPASI]{$invoiceid} pada Kolom Berita untuk bisa terproses secara otomatis. Namun Jika Nominal Transfer tidak sesuai dan tidak menggunakan Berita Transfer, Mohon Konfirmasikan Pembayaran Anda ke email <a href="mailto:payment@goldenfast.net"><b>payment@goldenfast.net</b></a><br>Aktivasi pesanan yang pembayarannya menggunakan Bank Transfer hanya dilakukan pada jam kerja Administratif : Senin-Jumat pukul 07.30 – 20.00 WIB, Sabtu – Minggu 07:30 – 18:00 WIB.</p>
            </br>
            {elseif $InvoicePaymentMethod == 'mailin'}
            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr class="title textcenter">
                <td class="total-row"><strong>PT Jejaring Cepat Indonesia</strong></td>
                <td class="total-row"><strong>No Rekening</strong></td>
            </tr>
            <tr class="title textcenter">
                <td class="total-row text-left">Bank Central Asia KCP WISMA MULIA</td>
                <td class="total-row">503-515-6001</td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'banktransfer2'}
            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr class="title textcenter">
                <td class="total-row"><strong>PT Jejaring Cepat Indonesia</strong></td>
                <td class="total-row"><strong>No Rekening</strong></td>
            </tr>
            <tr class="title textcenter">
                <td class="total-row text-left">Bank Of China Jakarta Branch</td>
                <td class="total-row">100000900281644</td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'biiva'}
            <br><center><strong><p>No Virtual Account BII:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BII VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr>
                <td class="total-row">
                    
                    <div class="accordion">
            		<h3>ATM BII</h3>
            		<div>
            			<ol>
                        <li>Pilih Menu Pembayaran/Top Up Pulsa</li>
                        <li>Pilih Virtual Account</li>
                        <li>Input Nomor Virtual Account  <b><span>{$nova}</span></b> </li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Pilih Benar</li>
                        <li>Pilih Ya</li>
                        <li>Ambil bukti bayar anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>SMS Banking BII</h3>
            		<div>
            			<ol>
                        <li>SMS ke 69811</li>
                        <li>Ketik TRANSFER (Nomor Virtual Account) (Nominal)</li>
                        <li>Contoh: TRANSFER  <b><span>{$nova}</span></b> <b>{$totalfixed}</b></li>
                        <li>Kirim SMS</li>
                        <li>Anda akan mendapat balasan Transfer dr rek &lt; nomor rekening anda &gt; ke rek &lt; Nomor Virtual Account &gt; sebesar Rp. 10.000 Ketik &lt; karakter acak &gt; Balas SMS tersebut, ketik &lt; karakter acak &gt;</li>
                        <li>Kirim SMS</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Internet Banking BII</h3>
            		<div>
            			<ol>
                        <li>Login Internet Banking</li>
                        <li>Pilih Rekening dan Transaksi</li>
                        <li>Pilih Maybank Virtual Account</li>
                        <li>Pilih Sumber Tabungan</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b> </li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Klik Submit</li>
                        <li>Input SMS Token</li>
                        <li>Bukti bayar ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'bniva'}
            <br><center><strong><p>No Virtual Account BNI:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BNI VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center><center><strong><p>BNI VA memerlukan waktu 10-15 menit untuk proses pengecekan transaksi dari sistem Bank BNI</p></strong></center></font>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM BNI</h3>
            		<div>
            			<ol>
                        <li>Pilih Menu Lain</li>
                        <li>Pilih Menu Transfer</li>
                        <li>Pilih Ke Rekening BNI</li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Masukkan Nomor Virtual Account. {$nova}</li>
                        <li>Pilih Ya</li>
                        <li>Ambil Bukti Pembayaran Anda.</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>SMS Banking BNI</h3>
            		<div>
            			<ol>
                        <li>Masuk Aplikasi SMS Banking BNI.</li>
                        <li>Pilih Menu Transfer</li>
                        <li>Pilih Trf Rekening BNI</li>
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b> </li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Pilih Proses</li>
                        <li>Pada Pop Up Message, Pilih Setuju</li>
                        <li>Anda Akan Mendapatkan Pesan Konfirmasi.</li>
                        <li>Masukkan 2 Angka Dari PIN Anda Dengan Mengikuti Petunjuk Yang Tertera Pada Pesan.</li>
                        <li>Bukti Pembayaran Ditampilkan.</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Internet Banking BNI</h3>
            		<div>
                		<ol>
                        <li>Pilih Transfer</li>
                        <li>Pilih Antar Rekening BNI</li>
                        <li>Pilih Rekening Tujuan</li>
                        <li>Pilih Input Rekening Baru</li>
                        <li>Masukkan Nomor Virtual Account sebagai Nomor Rekening <b><span>{$nova}</span></b> </li>
                        <li>Klik Lanjut</li>
                        <li>Klik Lanjut Kembali.</li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Klik Lanjut</li>
                        <li>Periksa Detail Konfirmasi. Pastikan Data Sudah Benar.</li>
                        <li>Jika Sudah Benar, Masukkan Password Transaksi</li>
                        <li>Klik Lanjut</li>
                        <li>Bukti Pembayaran Ditampilkan.</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'bcava'}
            <br><center><strong><p>No Virtual Account BCA:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BCA VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM BCA</h3>
            		<div>
            			<ol>
                        <li>Pilih Menu Transaksi Lainnya &gt; Transfer &gt; Ke rekening BCA Virtual Account</li>
                        <li>Input Nomor Virtual Account{$nova}</li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Pilih Benar</li>
                        <li>Pilih Ya</li>
                        <li>Ambil bukti bayar anda</li>
                        </ol>
            		</div>
            
            		<h3>Mobile Banking BCA</h3>
            		<div>
            			<ol>
                        <li>Login Mobile Banking &gt; m-Transfer &gt; BCA Virtual Account</li>
                        <li>Input Nomor Virtual Account{$nova}</li>
                        <li>Klik Send</li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Klik OK &gt; Input PIN Mobile Banking</li>
                        <li>Bukti bayar ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Internet Banking BCA</h3>
            		<div>
                		<ol>
                        <li>Login Internet Banking &gt; Transfer Dana &gt; Transfer Ke BCA Virtual Account</li>
                        <li>Input Nomor Virtual Account {$nova}</li>
                        <li>Klik Lanjutkan</li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Input Respon KeyBCA Appli 1</li>
                        <li>Klik Kirim</li>
                        <li>Bukti bayar ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'danamonva'}
            <br><center><strong><p>No Virtual Account Danamon:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Danamon VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Danamon</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Pembayaran -> Lainnya -> Virtual Account</li>
                        <li>Input Nomor Virtual Account  <b><span>{$nova}</span></b> </li>
                        <li>Pilih Benar</li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Pilih Ya</li>
                        <li>Ambil bukti bayar anda</li>
                        </ol>
            		</div>
            		<h3>Mobile Banking Danamon</h3>
            		<div>
                	   <ol>
                        <li>Login D-Mobile</li>
                        <li>Pilih menu Pembayaran ->Virtual Account -> Tambah Biller Baru Pembayaran -> Tekan Lanjut</li>
                        <li>Masukkan Nomor Virtual Account  <b><span>{$nova}</span></b> </li>
                        <li>Tekan Ajukan</li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Masukkan mPIN</li>
                        <li>Pilih Konfirmasi</li>
                        <li>Bukti bayar akan dikirim melalui sms</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'mandiriva'}
            <br><center><strong><p>No Virtual Account Mandiri:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Mandiri VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Mandiri</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Bayar/Beli</li>
                        <li>Pilih Lainnya</li>
                        <li>Pilih Multi Payment</li>
                        <li>Input 88049 sebagai Kode Institusi</li>
                        <li>Input Virtual Account Number  <b><span>{$nova}</span></b> </li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Pilih Benar</li>
                        <li>Pilih Ya</li>
                        <li>Pilih Ya</li>
                        <li>Ambil bukti bayar anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Mobile Banking Mandiri</h3>
            		<div>
            			<ol>
                        <li>Login Mobile Banking</li>
                        <li>Pilih Bayar</li>
                        <li>Pilih Multi Payment</li>
                        <li>Input Nicepay sebagai Penyedia Jasa</li>
                        <li>Input Nomor Virtual Account  <b><span>{$nova}</span></b> </li>
                        <li>Pilih Lanjut</li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Input OTP and PIN</li>
                        <li>Pilih OK</li>
                        <li>Bukti bayar ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Internet Banking Mandiri</h3>
            		<div>
                	    <ol>
                        <li>Login Internet Banking</li>
                        <li>Pilih Bayar</li>
                        <li>Pilih Multi Payment</li>
                        <li>Input Nicepay sebagai Penyedia Jasa</li>
                        <li>Input Nomor Virtual Account  <b><span>{$nova}</span></b> sebagai Kode Bayar</li>
                        <li>Ceklis IDR</li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Klik Lanjutkan</li>
                        <li>Bukti bayar ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'briva'}
            <br><center><strong><p>No Virtual Account BRI:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BRI VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM BRI</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Transaksi Lain</li>
                        <li>Pilih Menu Pembayaran</li>
                        <li>Pilih Menu Lain-lain</li>
                        <li>Pilih Menu BRIVA</li>
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b> </li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Pilih Ya</li>
                        <li>Ambil Bukti Pembayaran Anda.</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Mobile Banking BRI</h3>
            		<div>
            			<ol>
                        <li>Login BRI Mobile</li>
                        <li>Pilih Mobile Banking BRI</li>
                        <li>Pilih Menu Pembayaran</li>
                        <li>Pilih Menu BRIVA</li>
                        <li>Masukkan Nomor Virtual Account sebagai Nomor Rekening <b><span>{$nova}</span></b> </li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Klik Ok</li>
                        <li>Masukkan PIN Mobile</li>
                        <li>Klik Kirim</li>
                        <li>Bukti bayar akan dikirim melalui sms</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Internet Banking BRI</h3>
            		<div>
                	    <ol>
                        <li>Login Internet Banking</li>
                        <li>Pilih Pembayaran</li>
                        <li>Pilih BRIVA</li>
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b> </li>
                        <li>Klik Kirim</li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Masukkan Password</li>
                        <li>Masukkan mToken</li>
                        <li>Klik Kirim</li>
                        <li>Bukti bayar akan ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'cimbva'}
            <br><center><strong><p>No Virtual Account CIMB:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran CIMB VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM CIMB</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Transaksi Lainnya</li>
                        <li>Pilih Pembayaran</li>
                        <li>Pilih Pembayaran Lain-lain</li>
                        <li>Pilih Virtual Account</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Select Benar</li>
                        <li>Select Ya</li>
                        <li>Ambil bukti bayar anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Mobile Banking CIMB</h3>
            		<div>
            			<ol>
                        <li>Login Go Mobile</li>
                        <li>Pilih Menu Transfer</li>
                        <li>Pilih Menu Other Rekening Ponsel/CIMB Niaga</li>
                        <li>Pilih Sumber Dana yang akan digunakan</li>
                        <li>Pilih Casa</li>
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b> </li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Klik Lanjut</li>
                        <li>Data Virtual Account akan ditampilkan</li>
                        <li>Masukkan PIN Mobile</li>
                        <li>Klik Konfirmasi</li>
                        <li>Bukti bayar akan dikirim melalui sms</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Internet Banking CIMB</h3>
            		<div>
                	    <ol>
                        <li>Login Internet Banking</li>
                        <li>Pilih Bayar Tagihan</li>
                        <li>Rekening Sumber - Pilih yang akan Anda digunakan</li>
                        <li>Jenis Pembayaran - Pilih Virtual Account</li>
                        <li>Untuk Pembayaran - Pilih Masukkan Nomor Virtual Account</li>
                        <li>Nomor Rekening Virtual <b><span>{$nova}</span></b> </li>
                        <li>Isi Remark Jika diperlukan</li>
                        <li>Klik Lanjut</li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Masukkan mPIN</li>
                        <li>Klik Kirim</li>
                        <li>Bukti bayar akan ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'permatabankva'}
            <br><center><strong><p>No Virtual Account Permata Bank:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Permata Bank VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Permata Bank</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Transaksi Lainnya</li>
                        <li>Pilih Pembayaran</li>
                        <li>Pilih Pembayaran Lain-lain</li>
                        <li>Pilih Virtual Account</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b> </li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Select Benar</li>
                        <li>Select Ya</li>
                        <li>Ambil bukti bayar anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Mobile Banking Permata Bank</h3>
            		<div>
            			<ol>
                        <li>Login Mobile Banking</li>
                        <li>Pilih Pembayaran Tagihan</li>
                        <li>Pilih Virtual Account</li>
                        <li>Input Nomor Virtual Account  <b><span>{$nova}</span></b> sebagai No. Virtual Account</li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Klik Kirim</li>
                        <li>Input Token</li>
                        <li>Klik Kirim</li>
                        <li>Bukti bayar akan ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Internet Banking Permata Bank</h3>
            		<div>
                	    <ol>
                        <li>Login Internet Banking</li>
                        <li>Pilih Pembayaran Tagihan</li>
                        <li>Pilih Virtual Account</li>
                        <li>Input Nomor Virtual Account  <b><span>{$nova}</span></b> sebagai No. Virtual Account</li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Klik Kirim</li>
                        <li>Input Token</li>
                        <li>Klik Kirim</li>
                        <li>Bukti bayar akan ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'atmbersamava'}
            <br><center><strong><p>No Virtual Account ATM Bersama:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran ATM Bersama VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                        <li>Masukan Kartu ATM ke mesin ATM yang mendukung ATM Bersama</li>
                        <li>Pilih Bahasa</li>
                        <li>Masukkan PIN</li>
                        <li>Pilih Transaksi Lainnya &gt; Transfer &gt; Ke Rekening Bank Lain ATM Bersama/Link</li>
                        <li>Masukkan nomor rekening tujuan Kode Bank Permata (013) + 16 Digit Virtual Account  <b><span>{$nova}</span></b> , lalu tekan “Benar” </li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Isi atau kosongkan nomor referensi transfer kemudian tekan “Benar”</li>
                        <li>Selesai</li>
                        </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'hanabankva'}
            <br><center><strong><p>No Virtual Account Hana Bank:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Hana Bank VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="items">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Hana Bank</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Pembayaran</li>
                        <li>Pilih Lainnya</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b> </li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Pilih Benar</li>
                        <li>Pilih Ya</li>
                        <li>Ambil bukti bayar anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            		<h3>Internet Banking Hana Bank</h3>
            		<div>
                	   <ol>
                        <li>Login Internet Banking</li>
                        <li>Pilih menu Transfer kemudian Pilih Withdrawal Account Information</li>
                        <li>Pilih Account Number anda</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b> </li>
                        <li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Click Submit</li>
                        <li>Input SMS Pin</li>
                        <li>Bukti bayar akan ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {else}
            <p>Mohon Lakukan Pembayaran secara PENUH ke:</p></br>
            <div class="table-responsive">
                <table class="table">
            <tbody>
            <tr>
                <td class="total-row"><strong>PT Jejaring Cepat Indonesia</strong></td>
                <td class="total-row"><strong>No Rekening</strong></td>
            </tr>
            <tr>
                <td class="total-row text-left">Bank Central Asia KCP WISMA MULIA</td>
                <td class="total-row">5035-135-488</td>
            </tr>
            <tr>
                <td class="total-row text-left">Bank Mandiri KCP WISMA MULIA Jakarta</td>
                <td class="total-row">07-000-1-222-1-888</td>  
            </tr> 
          
            </tbody>
            </table>
           
            {/if}
            </center>
<br>
<br>
<p><b>{$LANG.infofakturpajakjudul}</b></p>
<p>{$LANG.infofakturpajak}</p>
<p>{$LANG.infofakturpajak2}</p>


            <div class="transactions-container small-text">
                <div class="table-responsive">
                    <table class="table table-condensed">
                        <thead>
                            <tr>
                                <td class="text-center"><strong>{$LANG.invoicestransdate}</strong></td>
                                <td class="text-center"><strong>{$LANG.invoicestransgateway}</strong></td>
                                <td class="text-center"><strong>{$LANG.invoicestransid}</strong></td>
                                <td class="text-center"><strong>{$LANG.invoicestransamount}</strong></td>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$transactions item=transaction}
                                <tr>
                                    <td class="text-center">{$transaction.date}</td>
                                    <td class="text-center">{$transaction.gateway}</td>
                                    <td class="text-center">{$transaction.transid}</td>
                                    <td class="text-center">{$transaction.amount}</td>
                                </tr>
                            {foreachelse}
                                <tr>
                                    <td class="text-center" colspan="4">{$LANG.invoicestransnonefound}</td>
                                </tr>
                            {/foreach}
                            <tr>
                                <td class="text-right" colspan="3"><strong>{$LANG.invoicesbalance}</strong></td>
                                <td class="text-center">{$balance}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="pull-right btn-group btn-group-sm hidden-print">
                <a href="javascript:window.print()" class="btn btn-default"><i class="fas fa-print"></i> {$LANG.print}</a>
                <a href="dl.php?type=i&amp;id={$invoiceid}" class="btn btn-default"><i class="fas fa-download"></i> {$LANG.invoicesdownload}</a>
            </div>

        {/if}

    </div>

    <p class="text-center hidden-print"><a href="clientarea.php">{$LANG.invoicesbacktoclientarea}</a></a></p>
    <script src="templates/{$template}/js/accordion.js"></script>
</body>
</html>
