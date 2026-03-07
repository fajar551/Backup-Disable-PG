<!DOCTYPE html>
<html lang="en">
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$companyname} - {$pagetitle}</title>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="templates/{$template}/css/accordion.css">
    <link href="{$BASE_PATH_CSS}/bootstrap.min.css" rel="stylesheet">
    <link href="{$BASE_PATH_CSS}/font-awesome.min.css" rel="stylesheet">

    <!-- Styling -->
    <link href="templates/{$template}/css/overrides.css" rel="stylesheet">
    <link href="templates/{$template}/css/styles.css" rel="stylesheet">
    <link href="templates/{$template}/css/invoice.css" rel="stylesheet">
    
	<script src="templates/{$template}/js/jquery-3.0.0.min.js"></script>
	<script src="templates/{$template}/js/copytext.js"></script>
	<!-- <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> -->
	{literal}
	<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-NDDL7BP');</script>
<!-- End Google Tag Manager -->
{/literal}
<style>
    .btn-delete{
        background-color:red; 
        color:white; 
        border:0px;
        border-radius:3px;
        padding: 3px 6px !important;
    }
    .btn-delete:hover{
        background-color:#a70000; 
        color:white; 
        border:0px;
    }
    
    .btn-secondary{
        border: 1px solid #aaaaaa;
    }
    
    .btn-secondary:hover{
        background-color: #a7a7a7;
    }
    
    .modal {
      display: none; /* Hidden by default */
      position: fixed; /* Stay in place */
      z-index: 10; /* Sit on top */
      padding-top: 100px; /* Location of the box */
      left: 0;
      top: 0;
      width: 100%; /* Full width */
      height: 100%; /* Full height */
      overflow: auto; /* Enable scroll if needed */
      background-color: rgb(0,0,0); /* Fallback color */
      background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
    }
    
    /* Modal Content */
    .modal-custom {
      background-color: #fefefe;
      margin: auto;
      padding: 20px;
      border: 1px solid #888;
      max-width: 380px;
      display:flex;
      flex-direction: column;
      gap:20px;
      border-radius: 8px;
    }
    
    .modal-header-custom {
      display:flex;
      flex-direction:row;
      justify-content: space-between;
    }
    
    .modal-header-custom > p {
      font-weight:semibold;
      font-size: 16px;
      align-self: center;
      margin-bottom:0px;
    }
    
    .modal-content-custom {
        min-height: 100px;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }
    
    .modal-footer-custom {
        display: flex;
        flex-direction: row;
        gap: 10px;
    }
    
    .modal-footer-custom > button {
        width:100%;
    }
    
    /* The Close Button */
    .close {
      color: #000;
      float: right;
      font-size: 28px;
      font-weight: bold;
    }
    
    .close:hover,
    .close:focus {
      color: #000;
      text-decoration: none;
      cursor: pointer;
    }
</style>
</head>
<body>
    {literal}
    <!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-NDDL7BP"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
<script>
    let urlParams = new URLSearchParams(window.location.search);
    let invoiceid_param = urlParams.get('id');
    function ChangeComma(){
    	str = document.usecredit.creditamount.value;
    	res = str.replace(" ", "");
    	res2 = res.replace(",", ".");
    	document.usecredit.creditamount.value = res2;
    	document.getElementById("usecredit").submit();
    }
    function deleteItem(id, clientid, type){
        let modalLoader = document.getElementById("modal_loader");
        let loader = document.getElementById("loader");
        let content = document.getElementById("content-loader");
        
        if(!invoiceid_param){
            alert(`invoiceid tidak ditemukan`);
            return;
        }
        
        modalLoader.style.display = "flex";
        loader.style.display = "flex";
        content.textContent = "Sedang menghapus item, mohon tunggu..."
        
        fetch('/apis/deleteItemInvoice.php?itemid=' + id + '&invoiceid=' + invoiceid_param + '&clientid=' + clientid + '&type=' + type)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error!`);
                }
                
                return response.json();
            })
            .then(data => {
                location.reload();
            })
            .catch(error => {
                modalLoader.style.display = "none";
                loader.style.display = "none";
                console.error('Fetch error:', error);
            });
    }
    
    function splitItem(id, clientid, type){
        let modalLoader = document.getElementById("modal_loader");
        let loader = document.getElementById("loader");
        let content = document.getElementById("content-loader");
        
        if(!invoiceid_param){
            alert(`invoiceid tidak ditemukan`);
            return;
        }
        
        modalLoader.style.display = "flex";
        loader.style.display = "flex";
        content.textContent = "Sedang meng-split item, mohon tunggu..."
        
        fetch('/apis/splitItemInvoice.php?itemid=' + id + '&invoiceid=' + invoiceid_param + '&clientid=' + clientid + '&type=' + type)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error!`);
                }
                
                return response.json();
            })
            .then(data => {
                if (data.code === 200 && data.new_invoice_id) {
                    const newInvoiceUrl = '/viewinvoice.php?id=' + data.new_invoice_id;
                    window.open(newInvoiceUrl, '_blank'); // Open new invoice in a new tab
                }
                
                location.reload();
            })
            .catch(error => {
                modalLoader.style.display = "none";
                loader.style.display = "none";
                console.error('Fetch error:', error);
            });
    }

</script>

    {/literal}

    <div class="container-fluid invoice-container">
    {checkhalfinvoice invoiceid=$invoiceid}
        {if $invalidInvoiceIdRequested}

            {include file="$template/includes/panel.tpl" type="danger" headerTitle=$LANG.error bodyContent=$LANG.invoiceserror bodyTextCenter=true}

        {else}

            <div class="row">
                <div class="col-sm-7">

                    {if $logo}
                        <p><img src="{$logo}" title="{$companyname}" /></p>
                    {else}
                        <h2>{$companyname}</h2>
                    {/if}
                    <h3>{$pagetitle}</h3>

                </div>
                <div class="col-sm-5">

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
                        {/if}
                    </div>

                    {if $status eq "Unpaid" || $status eq "Draft"}
                        <div class="small-text">
                            {$LANG.invoicesdatedue}: {$datedue}
                        </div>
                        <div class="payment-btn-container" align="center">
                            {$paymentbutton}
                        </div>
                    {/if}

                </div>
            </div>

            <hr>

            {if $paymentSuccess}
                {include file="$template/includes/panel.tpl" type="success" headerTitle=$LANG.success bodyContent=$LANG.invoicepaymentsuccessconfirmation bodyTextCenter=true}
            {elseif $pendingReview}
                {include file="$template/includes/panel.tpl" type="info" headerTitle=$LANG.success bodyContent=$LANG.invoicepaymentpendingreview bodyTextCenter=true}
            {elseif $paymentFailed}
                {include file="$template/includes/panel.tpl" type="danger" headerTitle=$LANG.error bodyContent=$LANG.invoicepaymentfailedconfirmation bodyTextCenter=true}
            {elseif $offlineReview}
                {include file="$template/includes/panel.tpl" type="info" headerTitle=$LANG.success bodyContent=$LANG.invoiceofflinepaid bodyTextCenter=true}
            {/if}

            <div class="row">
                {if $clientsdetails.id == '49345'}
                <div class="col-sm-6 pull-sm-right text-right-sm">
                    <strong>{$LANG.invoicespayto}:</strong>
                    <address class="small-text">
                        GEDUNG CYBER I LANTAI 3 JL KUNINGAN BARAT NO.08,  RT 001,  RW 003, KUNINGAN BARAT, MAMPANG PRAPATAN, KOTA ADM. JAKARTA SELATAN, DKI JAKARTA 12710
                    </address>
                </div>
                {else}
                <div class="col-sm-6 pull-sm-right text-right-sm">
                    <strong>{$LANG.invoicespayto}:</strong>
                    <address class="small-text">
                        {$payto}
                    </address>
                </div>
                {/if}
                <div class="col-sm-6">
                    <strong>{$LANG.invoicesinvoicedto}</strong>
                    <address class="small-text">
                        {if $clientsdetails.companyname}{$clientsdetails.companyname}<br />{/if}
                        {$clientsdetails.firstname} {$clientsdetails.lastname}<br />
                        {$clientsdetails.address1}, {$clientsdetails.address2}<br />
                        {$clientsdetails.city}, {$clientsdetails.state}, {$clientsdetails.postcode}<br />
                        {$clientsdetails.country}
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
                <div class="col-sm-6">
                    <strong>{$LANG.currentpaymentmethod}: {$paymentmethod}</strong><br><br>
                    
                    {if $paymentmethod == 'Bank Transfer BRI (Rupiah)' || $paymentmethod == 'Bank Transfer Mandiri (Rupiah)' || $paymentmethod == 'Bank Transfer BCA (Rupiah) (Manual Processing)' }
                    Mohon Konfirmasikan Pembayaran Anda ke email <a href="mailto:billing@qwords.com"><b>Billing@qwords.com</b></a><br>Aktivasi pesanan yang pembayarannya menggunakan Bank Transfer hanya dilakukan pada jam kerja Administratif : Senin-Jumat pukul 07.30 – 20.00 WIB, Sabtu – Minggu 07:30 – 18:00 WIB.<br><br>
                    {/if}
                    <span class="small-text">{$LANG.changepaymentmethod}:
                        {if $status eq "Unpaid" && $allowchangegateway && $halfinvoice == 'tidak'}
                            <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}" class="form-inline">
                                <input name="token" value={$token} type="hidden">
                                <select name="gateway" onchange="submit()" class="form-control select-inlinenew">
                                    <option value="">{$LANG.choosegateway}</option>
                                    <optgroup label = "Virtual Account">
                                    <option value="bcavad">BCA VA</option>
                                    <option value="mandirivad">Mandiri VA</option>
                                    <option value="brivad">BRI VA</option>
                                    <option value="bniva">BNI VA</option>
                                    <option value="atmbersamavad">ATM Bersama VA</option>
                                    <option value="biivad">BII VA</option>
                                    <option value="cimbvad">CIMB VA</option>
                                    <option value="permatabankvad">Permata Bank VA</option>
                                    <option value="danamonvad">Danamon VA</option>
                                    <option value="sampoernava">Sampoerna VA</option>
                                    <option value="hanabankvad">Hana Bank VA</option>
                                    <option value="bsiva">BSI VA</option>
                                    <option value="bncva">BNC VA</option>
                                    <option value="bjbva">BJB VA</option>
                                    <option value="sinarmasva">Sinarmas VA</option>
                                    <option value="bankdkiva">Bank DKI VA</option>
                                    <option value="oy">Bank BTPN VA</option>
                                    <optgroup label = "Bank Transfer">
                                    <option value="bcaapi">BCA</option>
                                    <option value="banktransfermandiri">Mandiri</option>
                                    <option value="banktransfermaybank">Maybank</option>
                                    <optgroup label = "Credit Card, Alfamart, etc">
                                    <option value="ipay88">Credit Card</option>
                                    <option value="ccmidtrans">Credit Card Midtrans</option>
                                    <option value="duitku_varitel">Alfamart</option>
                                    <option value="duitku_varitel">Pegadaian</option>
                                     <option value="stripe">Stripe</option>
                                    <option value="duitku_varitel">Pos Indonesia</option>
                                    <option value="veritransindomaret">Indomaret</option>
                                    <option value="dokuwallet">DOKU Wallet</option>
                                    <option value="indodana">Indodana</option>
                                    <!-- <option value="ipay88_kredivo">Kredivo</option> -->
                                    <option value="xenditakulaku">Akulaku</option>
                                    <option value="shopeeXendit">ShopeePay</option>
                                    <option value="nicepayjeniuspay">JeniusPay</option>
                                    <option value="xendit">DANA</option>
                                    <option value="veritrans">Go-Pay</option>
                                    <option value="xenditOvo">OVO</option>
                                    <option value="xenditqris">QRIS</option>
                                    <option value="banktransfer2">Cash Payment @Qwords Office / Exhibition</option>
                                    <option value="paypal">PayPal</option>
                                </select>
                            </form>
                        {else}
                            {$paymentmethod}
                        {/if}
                    </span>
                    <br /><br />
                </div>
                <div class="col-sm-6 text-right-sm">
                    <strong>{$LANG.invoicesdatecreated}:</strong><br>
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
                        <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}" name="usecredit" onsubmit="ChangeComma();">
                            <input type="hidden" name="applycredit" value="true" />
                            {$LANG.invoiceaddcreditdesc1} <strong>{$totalcredit}</strong>. {$LANG.invoiceaddcreditdesc2}. {$LANG.invoiceaddcreditamount}:
                            <div class="row">
                                <div class="col-xs-8 col-xs-offset-2 col-sm-4 col-sm-offset-4">
                                    <div class="input-group">
                                        <input type="text" name="creditamount" value="{if $totalcredit|strstr:','}{$creditamount|replace:'.':','}{else}{$creditamount}{/if}" class="form-control"/>
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
                            {assign var="validItemCount" value=0}
                            {foreach from=$invoiceitems item=item}
                                {if $item.type|lower == "hosting"}
                                    {assign var="hosting" value=$item.relid}
                                    {foreach from=$renewalHostings item=renewalHosting}
                                        {if $renewalHosting.relid == $item.relid && $renewalHosting.renewal}
                                            {assign var="validItemCount" value=$validItemCount+1}
                                        {/if}
                                    {/foreach}
                                {elseif $item.type|lower == "domain"}
                                    {assign var="validItemCount" value=$validItemCount+1}
                                {/if}
                            {/foreach}
                            
                            <thead>
                                <tr>
                                    <td><strong>{$LANG.invoicesdescription}</strong></td>
                                    <td class="text-center" {if $validItemCount < 2}style="display:none"{/if}><strong>Action</strong></td>
                                    <td width="20%" class="text-center"><strong>{$LANG.invoicesamount}</strong></td>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$invoiceitems item=item}  
                                    <tr>
                                        <td>{$item.description}{if $item.taxed eq "true"} *{/if}</td>  <!-- Menampilkan deskripsi item -->
                                        {if $validItemCount > 1}  <!-- Memeriksa apakah validItemCount lebih dari 1 -->
                                            <td class="text-center" style="display:flex; gap:5px;">  <!-- Jika ya, tampilkan kolom aksi -->
                                                {if $item.type|lower == "hosting"}  <!-- Memeriksa apakah tipe item adalah "hosting" -->
                                                    {foreach from=$renewalHostings item=renewalHosting}
                                                        {if $renewalHosting.relid == $item.relid && $renewalHosting.renewal && !$hasZeroAmountDomain}
                                                            <!-- Menampilkan tombol Split dan Delete untuk hosting hanya jika tidak ada domain dengan amount 0 -->
                                                            <button onclick="openModal('modalSplitItem', '{$item.id}', {$clientsdetails.client_id}, 'hosting')" class="btn-outline">Split</button>
                                                            <button onclick="openModal('modalDeleteItem', '{$item.id}', {$clientsdetails.client_id}, 'hosting')" class="btn-delete">Delete</button>
                                                        {/if}
                                                    {/foreach}
                                                {elseif $item.type|lower == "domain"}  <!-- Memeriksa apakah tipe item adalah "domain" -->
                                                    {foreach from=$renewalHostings item=renewalHosting}
                                                        {if $renewalHosting.relid == $item.relid}
                                                            <!-- Tampilkan tombol Split dan Delete untuk domain jika amount lebih dari 0 -->
                                                            {if $item.amount > 0}
                                                                <button onclick="openModal('modalSplitItem', '{$item.id}', {$clientsdetails.client_id}, 'domain')" class="btn-outline">Split</button>
                                                                <button onclick="openModal('modalDeleteItem', '{$item.id}', {$clientsdetails.client_id}, 'domain')" class="btn-delete">Delete</button>
                                                            {/if}
                                                        {/if}
                                                    {/foreach}
                                                {/if}
                                            </td>
                                        {/if}
                                        <td class="text-center">{$item.amount}</td>  <!-- Menampilkan jumlah item -->
                                    </tr>
                                {/foreach}
                                <tr>
                                    <td class="text-center" {if $validItemCount < 2}style="display:none"{/if}></td>
                                    <td class="total-row text-right"><strong>{$LANG.invoicessubtotal}</strong></td>
                                    <td class="total-row">{$subtotal}</td>
                                </tr>
                                {if $taxrate}
                                    <tr>
                                        <td class="text-center" {if $validItemCount < 2}style="display:none"{/if}></td>
                                        <td class="total-row text-right"><strong>{$taxname}</strong></td>
                                        <td class="total-row">{$tax}</td>
                                    </tr>
                                {/if}
                                {if $taxrate2}
                                    <tr>
                                        <td class="text-center" {if $validItemCount < 2}style="display:none"{/if}></td>
                                        <td class="total-row text-right"><strong>{$taxname2}</strong></td>
                                        <td class="total-row">{$tax2}</td>
                                    </tr>
                                {/if}
                                <tr>
                                    <td class="text-center" {if $validItemCount < 2}style="display:none"{/if}></td>
                                    <td class="total-row text-right"><strong>{$LANG.invoicescredit}</strong></td>
                                    <td class="total-row">{$credit}</td>
                                </tr>
                                <tr>
                                    <td class="text-center" {if $validItemCount < 2}style="display:none"{/if}></td>
                                    <td class="total-row text-right"><strong>{$LANG.invoicestotal}</strong></td>
                                    <td class="total-row">{$total}</td>
                                </tr>
                            </tbody>

                        </table>
                    </div>
                </div>
            </div>

            {if $taxrate}
                <p>* {$LANG.invoicestaxindicator}</p>
            {/if}
            {banktransfercheck total=$total paymentmethod=$paymentmethod}
            {invoicedetail invoice=$invoiceid}
            {vainvoice va=$InvoicePaymentMethod clientid=$clientsdetails.id invoiceid=$invoiceid}
            {if $InvoicePaymentMethod == 'banktransfer'}
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <p>Mohon Lakukan Pembayaran secara PENUH ke:</p></br>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row"><strong>PT Qwords Company International</strong></td>
                <td class="total-row"><strong>No Rekening</strong></td>
            </tr>
            <tr>
                <td class="total-row text-left">Bank Central Asia KC Wisma Mulia Jakarta</td>
                <td class="total-row">503-5778-770</td>
            </tr>
            <tr>
                <td class="total-row text-left">Bank Mandiri KC Suropati Bandung</td>
                <td class="total-row">131-00-12210-888</td>  
            </tr>
            </tr>
            </tbody>
            </table>
            </br>
            <p>*Proses Pemeriksaan Pembayaran bisa memakan waktu 2 Hari Kerja. Masukkan INVOICE# {$invoiceid} pada Kolom Berita Transfer. Harap Kirimkan Bukti Transfer ke billing@qwords.com untuk mempercepat proses.</p>
            </br>
            {elseif $InvoicePaymentMethod == 'bcaapi'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            </br>
            <p>Mohon Lakukan Pembayaran secara PENUH ke:</p>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row"><strong>PT Qwords Company International</strong></td>
                <td class="total-row"><strong>No Rekening</strong></td>
            </tr>
            <tr>
                <td class="total-row text-left">Bank Central Asia KC Wisma Mulia Jakarta</td>
                <td class="total-row">503-5778-770</td>
            </tr>
             </tbody>
            </table>
            </br>
            <p>*Masukkan INVOICE# {$invoiceid} pada Kolom Berita. Jika Nominal Transfer tidak sesuai dan tidak menggunakan Berita Transfer, Mohon Konfirmasikan Pembayaran Anda ke email <a href="mailto:billing@qwords.com"><b>Billing@qwords.com.</b></a><br>Aktivasi pesanan yang pembayarannya menggunakan Bank Transfer hanya dilakukan pada jam kerja Administratif : Senin-Jumat pukul 07.30 – 20.00 WIB, Sabtu – Minggu 07:30 – 18:00 WIB.</p>
            </br>
            {elseif $InvoicePaymentMethod == 'banktransfermandiri'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br>
            <p>Mohon Lakukan Pembayaran secara PENUH ke:</p>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row"><strong>PT Qwords Company International</strong></td>
                <td class="total-row"><strong>No Rekening</strong></td>
            </tr>
            <tr>
                <td class="total-row text-left">Bank Mandiri KC Suropati Bandung</td>
                <td class="total-row">131-00-12210-888</td>  
            </tr> 
             </tbody>
            </table>
            </br>
            <p>*Masukkan INVOICE[SPASI]{$invoiceid} atau INV[SPASI]{$invoiceid} pada Kolom Berita untuk bisa terproses secara otomatis. Namun Jika Nominal Transfer tidak sesuai dan tidak menggunakan Berita Transfer, Mohon Konfirmasikan Pembayaran Anda ke email <a href="mailto:billing@qwords.com"><b>Billing@qwords.com.</b></a><br>Aktivasi pesanan yang pembayarannya menggunakan Bank Transfer hanya dilakukan pada jam kerja Administratif : Senin-Jumat pukul 07.30 – 20.00 WIB, Sabtu – Minggu 07:30 – 18:00 WIB.</p>
            </br>
             {elseif $InvoicePaymentMethod == 'banktransfermandiriki'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br>
            <p>Mohon Lakukan Pembayaran secara PENUH ke:</p>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row"><strong>PT Qwords Company International</strong></td>
                <td class="total-row"><strong>No Rekening</strong></td>
            </tr>
            <tr>
                <td class="total-row text-left">Bank Mandiri KCP Wisma Mulia</td>
                <td class="total-row">131-001-221-0888</td>  
            </tr> 
             </tbody>
            </table>
            <p>Mohon Konfirmasikan Pembayaran Anda ke email <a href="mailto:billing@qwords.com"><b>Billing@qwords.com.</b></a><br>Aktivasi pesanan yang pembayarannya menggunakan Bank Transfer hanya dilakukan pada jam kerja Administratif : Senin-Jumat pukul 07.30 – 20.00 WIB, Sabtu – Minggu 07:30 – 18:00 WIB.</p>
            </br>
            {elseif $InvoicePaymentMethod == 'nicepaygatewayva'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
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
            {elseif $InvoicePaymentMethod == 'xenditqrcode'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Klik Bayar Sekarang</li>
                    <li>QR Code akan muncul di layar desktop Anda. Jangan close dulu halaman ini.</li>
                    <li>Buka aplikasi Shopee melalui Smartphone Anda</li>
                    <li>Pilih menu Saya pada pojok kanan bawah</li>
                    <li>Lalu pilih menu ShopeePay</li>
                    <li>Klik menu Bayar dengan scan QR code</li>
                    <li>Arahkan Kamera ke QR Code yang muncul di layar desktop</li>
                    <li>Nominal dan nama merchant Qwords akan muncul di layar smartphone anda</li>
                    <li>Lalu klik Lanjutkan.</li>
                    <li>Masukkan pin ShopeePay Anda</li>
                    <li>Selesai</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'shopeeXendit'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Pastikan anda menggunakan smartphone yang sudah terinstall Aplikasi Shopee untuk membuka tagihan ini</li>
                    <li>Klik Bayar dengan ShopeePay</li>
                    <li>Nominal dan nama merchant Qwords akan muncul pada smartphone anda</li>
                    <li>Klik Lanjutkan</li>
                    <li>Pastikan ShopeePay anda mencukupi lalu klik Bayar Sekarang</li>
                    <li>Masukkan pin ShopeePay Anda</li>
                    <li>Selesai</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'nicepayakulaku'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Klik Pay Now</li>
                    <li>Pilih Pinjaman Online -> Akulaku</li>
                    <li>Klik Lakukan Pembayaran</li>
                    <li>Tunggu 5 Detik Layar akan redirect ke Halaman Login Akulaku</li>
                    <li>Login/Daftar Akun Akulaku</li>
                    <li>Pastikan Akun Akulaku masih mempunyai Credit Limit yang mencukupi</li>
                    <li>Lanjutkan dan Konfirmasi</li>
                    <li>Selesai</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'xenditakulaku'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Klik Pay via Xendit</li>
                    <li>Pilih Paylater -> Partner Akulaku</li>
                    <li>Isi Form Customer Information</li>
                    <li>Klik Continue</li>
                    <li>Pilih Cicilan</li>
                    <li>Login/Daftar Akun Akulaku</li>
                    <li>Pastikan Akun Akulaku masih mempunyai Credit Limit yang mencukupi</li>
                    <li>Scan QR Code</li>
                    <li>Lanjutkan dan Konfirmasi</li>
                    <li>Selesai</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'xenditqrjenius'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Klik Bayar Sekarang</li>
                    <li>QR Code akan muncul di layar desktop Anda. Jangan close dulu halaman ini</li>
                    <li>Buka aplikasi Jenius melalui Smartphone Anda</li>
                    <li>Pada Dashboard, PIlih Bayar dengan QR</li>
                    <li>Arahkan Kamera ke QR Code yang muncul di layar desktop</li>
                    <li>Nominal dan nama merchant Qwords akan muncul di layar smartphone anda</li>
                    <li>Lalu klik Lanjut</li>
                    <li>Lalu klik Bayar</li>
                    <li>Selesai</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
             {elseif $InvoicePaymentMethod == 'xenditqris'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Klik Bayar Sekarang</li>
                    <li>QR Code akan muncul di layar desktop Anda. Jangan close dulu halaman ini.</li>
                    <li>Buka aplikasi yang mendukung QRIS</li>
                    <li>Arahkan Kamera ke QR Code yang muncul di layar desktop</li>
                    <li>Nominal dan nama merchant Qwords akan muncul di layar smartphone anda</li>
                    <li>Selesaikan proses sesuai aplikasi yang digunakan</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'nicepaygateway'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
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
            {elseif $InvoicePaymentMethod == 'ipay88'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
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
             {elseif $InvoicePaymentMethod == 'ipay88ovo'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran OVO</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Klik Proceed Payment</li>
                    <li>Masukan Nomor Telepon/Akun OVO anda</li>
                    <li>Klik Proceed Payment</li>
                    <li>Notifikasi OVO akan muncul pada smartphone anda (pastikan Internet pada smartphone anda sudah aktif)</li>
                    <li>Buka notifikasi/aplikasi OVO</li>
                    <li>Setujui Pembayaran</li>
                    <li>Selesaikan dengan PIN/Fingerprint pada aplikasi OVO anda</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
              {elseif $InvoicePaymentMethod == 'xenditOvo'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran OVO</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Klik Pay Now</li>
                    <li>Masukan Nomor Telepon/Akun OVO anda</li>
                    <li>Klik Proceed Payment</li>
                    <li>Buka notifikasi/aplikasi OVO</li>
                    <li>Setujui Pembayaran</li>
                    <li>Selesaikan dengan PIN/Fingerprint pada aplikasi OVO anda</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
             {elseif $InvoicePaymentMethod == 'ipay88linkaja' || $InvoicePaymentMethod == 'xenditLinkAja'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran LinkAja</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Klik Proceed Payment</li>
                    <li>Masukan Nomor dan PIN LinkAja anda</li>
                    <li>Klik Lanjutkan</li>
                    <li>Kode Verifikasi Linkaja akan muncul pada smartphone anda (pastikan Internet pada smartphone anda sudah aktif)</li>
                    <li>Masukan Kode Verifikasi ke Kolom Kode Verifikasi</li>
                    <li>Selesaikan dengan Klik Proses</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'dokuwallet'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
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
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
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
            {elseif $InvoicePaymentMethod == 'duitku_varitel'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                   <ol>
                    <li>Klik Bayar Sekarang</li>
                    <li>Catat Nomor Payment Code yang muncul</li>
                    <li>Kunjungi Alfamart/Alfamidi/Law-son/DAN-DAN/Pegadaian/Kantor Pos Terdekat</li>
                    <li>Informasikan Nomor Payment Code ke kasir, informasikan untuk pembayaran FINPAY</li>
                    <li>Selesaikan pembayaran</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'bcaklikpay'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
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
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
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
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
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
            {elseif $InvoicePaymentMethod == 'banktransfer2'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <p style="padding: 10px;">Aktivasi pesanan yang pembayarannya menggunakan Bank Transfer hanya dilakukan pada jam kerja Administratif : Senin-Jumat pukul 07.30 – 20.00 WIB, Sabtu – Minggu 07:30 – 18:00 WIB.</p>
                    <p style="padding: 10px;">(Metode pembayaran ini hanya berlaku untuk pembayaran di kantor Qwords atau di acara pameran) Silakan lakukan pembayaran kepada tim Billing Qwords/ staff yang ditunjuk di lokasi.</p>
                    <ul>
                    <li>Jika diperlukan, Anda dapat mengubah ke metode pembayaran lain yang bersifat offsite melalui halaman <a href="https://portal.qwords.com/viewinvoice.php?id={$invoice_id}">ini</a></li>
                    </ul>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'biiva'}
            <br><center><strong><p>No Virtual Account BII:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BII VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM BII</h3>
            		<div>
            			<ol>
                        <li>Pilih Menu Pembayaran/Top Up Pulsa</li>
                        <li>Pilih Virtual Account</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Contoh: TRANSFER <b><span>{$nova}</span></b><b>{$totalfixed}</b></li>
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
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
             {elseif $InvoicePaymentMethod == 'biivad'}
            <br><center><strong><p>No Virtual Account Maybank:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Maybank VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Maybank</h3>
            		<div>
            			<ol>
                        <li>Pilih Menu Pembayaran/Top Up Pulsa</li>
                        <li>Pilih Virtual Account</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
                        <li>Pilih Benar</li>
                        <li>Pilih Ya</li>
                        <li>Ambil bukti bayar anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>SMS Banking Maybank</h3>
            		<div>
            			<ol>
                        <li>Klik App Maybank SMS+ Banking</li>
                        <li>Input Passcode (Jika ada)</li>
                        <li>Pilih Media Koneksi: SMS, USSD Atau Data (lihat indikator koneksi pada pojok kanan atas)</li>
                        <li>Menu Utama, Klik Icon Transfer</li>
                        <li>Pilih Virtual Account</li>
                        <li>Pada kolom Rekening Sumber, masukkan rekening sumber (Pada media koneksi USSD tidak diperlukan)</li>'
                        <li>Pada kolom Jumlah, Masukkan jumlah yang akan di bayarkan {$totalfixed}</li>
                        <li>Pada kolom No Ref/Berita, masukkan No Ref/Berita</li>
                        <li>Pada kolom Rekening Tujuan, Masukkan Nomor Virtual Account {$nova}</li>
                        <li>Klik Tombol Kirim</li>
                        <li>Masukkan PIN yang dikirim melalui SMS</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Internet Banking Maybank</h3>
            		<div>
            			<ol>
                        <li>Login Internet Banking</li>
                        <li>Pilih Rekening dan Transaksi</li>
                        <li>Pilih Maybank Virtual Account</li>
                        <li>Pilih Sumber Tabungan</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
            {elseif $InvoicePaymentMethod == 'bniva' || $InvoicePaymentMethod == 'bnivad'}
            <br><center><strong><p>No Virtual Account BNI:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BNI VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center><center><strong><p><br><br>BNI VA memerlukan waktu 10-15 menit untuk proses pengecekan transaksi dari sistem Bank BNI</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
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
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Masukkan Nomor Virtual Account sebagai Nomor Rekening <b><span>{$nova}</span></b></li>
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
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM BCA</h3>
            		<div>
            			<ol>
                        <li>Pilih Menu Transaksi Lainnya &gt; Transfer &gt; Ke rekening BCA Virtual Account</li>
                        <li>Input Nomor Virtual Account {$nova}</li>
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
                        <li>Input Nomor Virtual Account {$nova}</li>
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
            {elseif $InvoicePaymentMethod == 'bcavad'}
            <br><center><strong><p>No Virtual Account BCA:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BCA VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM BCA</h3>
            		<div>
            			<ol>
                        <li>Pilih Menu Transaksi Lainnya &gt; Transfer &gt; Ke rekening BCA Virtual Account</li>
                        <li>Input Nomor Virtual Account {$nova}</li>
                        <li>Pilih Benar</li>
                        <li>Pilih Ya</li>
                        <li>Ambil bukti bayar anda</li>
                        </ol>
            		</div>
            
            		<h3>Mobile Banking BCA</h3>
            		<div>
            			<ol>
                        <li>Login Mobile Banking &gt; m-Transfer &gt; BCA Virtual Account</li>
                        <li>Input Nomor Virtual Account {$nova}</li>
                        <li>Klik Send</li>
                        <li>Informasi Virtual Account akan ditampilkan</b></li>
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
            {elseif $InvoicePaymentMethod == 'mandiriva'}
            <br><center><strong><p>No Virtual Account Mandiri:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Mandiri VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
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
                        <li>Input Virtual Account Number <b><span>{$nova}</span></b></li>
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
                        <li>Login Mobile Banking (Pastikan Anda menggunakan aplikasi Mandiri Online terbaru)</li>
                        <li>Pilih Bayar</li>
                        <li>Pilih Multi Payment</li>
                        <li>Input Nicepay sebagai Penyedia Jasa</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b> sebagai Kode Bayar</li>
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
             {elseif $InvoicePaymentMethod == 'mandirivad'}
             {if $nova == 'Klik Bayar Sekarang di Pojok Kanan Atas Untuk Melihat Nomor VA'}
             <br><center><strong><font style="color:red !important;"><p>{$nova}</p></font></strong></center>
             {else}
            <br><center><strong><p>No Virtual Account Mandiri:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            {/if}
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Mandiri VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
                    <h3>New Livin by Mandiri</h3>
            		<div>
            			<ol>
                        <li>Login New Livin by Mandiri</li>
                        <li>Pilih Bayar</li>
                        <li>Pilih E-Commerce</li>
                        <li>Input Transferpay sebagai Penyedia Jasa</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
                        <li>Pilih Lanjut</li>
                        <li>Layar akan menampilkan Kode Bayar dan Data Pembayaran Jika data telah sesuai</li>
                        <li>Input PIN</li>
                        <li>Pilih OK</li>
                        <li>Bukti bayar ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            		<h3>ATM Mandiri</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Bayar/Beli</li>
                        <li>Pilih Lainnya</li>
                        <li>Pilih Multi Payment</li>
                        <li>Input 70014 sebagai Kode Biller</li>
                        <li>Input Virtual Account Number <b><span>{$nova}</span></b></li>
                        <li>Pilih Benar</li>
                        <li>Layar akan menampilkan Kode Bayar dan Data Pembayaran, kemudian tekan 1 Jika data telah sesuai</li>
                        <li>Pilih Ya</li>
                        <li>Ambil bukti bayar anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
                    <h3>ATM Non Mandiri</h3>
            		<div>
                		<ol>
                		<li>Pilih Menu Transfer Antar Bank Online</li>
                		<li>Input Kode Bank Mandiri 008 atau pilih Bank Mandiri di daftar Bank</li>
                		<li>Input Nomor Virtual Account sebagai Kode Bayar kemudian masukkan Nominal transfer</li>
                        <li>Layar akan menampilkan Kode Bayar dan Data Pembayaran, kemudian tekan 1 Jika data telah sesuai</li>
                        <li>Pilih Ya</li>
                        <li>Ambil bukti bayar anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            		<h3>Internet Banking Mandiri</h3>
            		<div>
                	    <ol>
                        <li>Login Internet Banking</li>
                        <li>Pilih Bayar</li>
                        <li>Pilih Multi Payment</li>
                        <li>Input Transferpay sebagai Penyedia Jasa</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b> sebagai Kode Bayar</li>
                        <li>Ceklis IDR</li>
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
            
            {elseif $InvoicePaymentMethod == 'sampoernava'}
            <br><center><strong><p>No Virtual Account Sahabat Sampoerna:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Sahabat Sampoerna VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Bank Sahabat Sampoerna</h3>
            		<div>
                		<ol>
                            <li>Pilih Menu Transaksi</li>
                            <li>Pilih Lainnya</li>
                            <li>Pilih Transfer</li>
                            <li>Pilih Transfer ke Bank Sahabat Sampoerna</li>
                            <li>Input Virtual Account Number {$nova}</li>
                            <li>Input Nominal</li>
                            <li>Select Benar</li>
                            <li>Select Ya</li>
                            <li>Ambil bukti bayar anda</li>
                            <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Mobile Banking Bank Sahabat Sampoerna</h3>
            		<div>
            			<ol>
                        <li>Login Mobile Banking</li>
                        <li>Pilih Transfer Dana</li>
                        <li>Pilih Transfer ke Antar Bank</li>
                        <li>Input kode Bank Sahabat yaitu 523</li>
                        <li>Pilih Ya</li>
                        <li>Input Nomor Virtual Account {$nova}</li>
                        <li>Input Nominal</li>
                        <li>Input token M-Banking anda</li>
                        <li>Bukti bayar ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Internet Banking Bank Sahabat Sampoerna</h3>
            		<div>
                	    <ol>
                        <li>Login Internet Banking</li>
                        <li>Pilih Transfer Dana</li>
                        <li>Pilih Transfer ke Rekening Bank Sahabat Sampoerna</li>
                        <li>Input Nomor Virtual Account {$nova}</li>
                        <li>Input Nominal</li>
                        <li>Input token i-Banking anda</li>
                        <li>Bukti bayar akan ditampilkan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'duitku_artha'}
            <br><center><strong><p>No Virtual Account Artha Graha:<br><input type="text" value="Klik Tombol Bayar Sekarang di Pojok Kanan Atas" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Artha Graha VA</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Artha Graha</h3>
            		<div>
                		<ol>
                            <li>Masukkan kartu ATM dan PIN ATM Artha Graha Anda</li>
                            <li>Pilih Menu Pembayaran > Pilih Menu Tagihan Lainnya.</li>
                            <li>Masukkan 16 digit nomor virtual account 8888xxxxxxxxxxxx( pastikan nomor sesuai )</li>
                            <li>Masukkan jumlah pembayaran sesuai dengan tagihan</li>
                            <li>Ikuti instruksi untuk menyelesaikan transaksi</li>
                            <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Teller Artha Graha</h3>
            		<div>
            			<ol>
                            <li>Isi slip setoran</li>
                            <li>Tulis keterangan nama serta nomor virtual account</li>
                            <li>Tulis Jumlah pembayaran (pastikan nominal jumlah sesuai dengan nominal VA)</li>
                            <li>Isi nominal pembayaran</li>
                            <li>Serahkan slip setoran ke teller</li>
                            <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>ATM Bersama/Prima</h3>
            		<div>
                	    <ol>
                        <li>Masukkan Pin</li>
                        <li>Pilih menu Transaksi Lainnya</li>
                        <li>Pilih menu Transfer</li>
                        <li>Pilih menu Antar Bank Online</li>
                        <li>Masukkan nomor Virtual Account (kode bank 037 dan 8888xxxxxxxxxxxx16 digit nomor Virtual Account)</li>
                        <li>Masukkan jumlah transfer sesuai tagihan atau kewajiban Anda. pastikan nominal sesuai. Pembayaran dengan jumlah yang tidak sesuai akan otomatis ditolak</li>
                        <li>Pada halaman konfirmasi transfer akan muncul jumlah yang dibayarkan & nomor rekening tujuan. Jika informasinya telah sesuai tekan tombol Benar.</li>
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
                <table class="table table-condensed">
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
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Masukkan Nomor Virtual Account sebagai Nomor Rekening <b><span>{$nova}</span></b></li>
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
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
            {elseif $InvoicePaymentMethod == 'brivad'}
            <br><center><strong><p>No Virtual Account BRI:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BRI VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
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
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Masukkan Nomor Virtual Account sebagai Nomor Rekening <b><span>{$nova}</span></b></li>
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
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM CIMB</h3>
            		<div>
                		<ol>
                        <li>Input Kartu ATM dan PIN Anda</li>
                        <li>Pilih Menu Transfer</li>
                        <li>Pilih Menu Rekening CIMB Niaga / Rekening Ponsel Lain</li>
                        <li>Pilih Menu Rekening CIMB Niaga Lain</li>
                        <li>Masukan nominal transaksi dan pilih OK</li>
                        <li>Masukkan Nomor Virtual Account {$nova} dan pilih OK</li>
                        <li>Pilih sumber rekening</li>
                        <li>Konfirmasi transfer dan pilih OK</li>
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
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Nomor Rekening Virtual <b><span>{$nova}</span></b></li>
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
            {elseif $InvoicePaymentMethod == 'cimbva'}
            <br><center><strong><p>No Virtual Account CIMB:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran CIMB VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM CIMB</h3>
            		<div>
                		<ol>
                        <li>Input Kartu ATM dan PIN Anda</li>
                        <li>Pilih Menu Transfer</li>
                        <li>Pilih Menu Rekening CIMB Niaga / Rekening Ponsel Lain</li>
                        <li>Pilih Menu Rekening CIMB Niaga Lain</li>
                        <li>Masukan nominal transaksi dan pilih OK</li>
                        <li>Masukkan Nomor Virtual Account {$nova} dan pilih OK</li>
                        <li>Pilih sumber rekening</li>
                        <li>Konfirmasi transfer dan pilih OK</li>
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
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Nomor Rekening Virtual <b><span>{$nova}</span></b></li>
                        <li>Isi Remark Jika diperlukan</li>
                        <li>Klik Lanjut</li>
                        <li>Data Virtual Account akan ditampilkan</li>
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
                <table class="table table-condensed">
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
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b> sebagai No. Virtual Account</li>
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
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b> sebagai No. Virtual Account</li>
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
            {elseif $InvoicePaymentMethod == 'permatabankvad'}
            <br><center><strong><p>No Virtual Account Permata Bank:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Permata Bank VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
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
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b> sebagai No. Virtual Account</li>
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
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b> sebagai No. Virtual Account</li>
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
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                        <li>Masukan Kartu ATM ke mesin ATM yang mendukung ATM Bersama</li>
                        <li>Masukkan PIN</li>
                        <li>Pilih Transaksi Lainnya &gt; Transfer &gt; Ke Rekening Bank Lain ATM Bersama/Link</li>
                        <li>Masukkan nomor rekening tujuan Kode Bank Permata (013) + 16 Digit Virtual Account <b><span>{$nova}</span></b>, lalu tekan “Benar” </li>
						<li>Input Nominal <b>{$totalfixed}</b></li>
                        <li>Isi atau kosongkan nomor referensi transfer kemudian tekan “Benar”</li>
                        <li>Selesai</li>
                        </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'veritrans'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran Go-Pay</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                        <li>Klik Continue</li>
                        <li>Pilih Go-Pay</li>
                        <li>Klik Pay with Go-Pay</li>
                        <li>Muncul QR-Code di layar PC/Laptop anda</li>
                        <li>Buka aplikasi Go-Jek di Smartphone anda</li>
                        <li>Pilih QR-Code</li>
                        <li>Arahkan Kamera Smartphone ke QR-Code di layar PC/Laptop anda</li>
                        <li>Setting PIN Go-Pay (jika belum pernah sebelumnya) kemudian Selesaikan Pembayaran</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'xendit'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran DANA</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                        <li>Klik Bayar Sekarang</li>
                        <li>Isi Nomor Telepon yang terdaftarkan pada akun DANA ke kotak tersedia</li>
                        <li>Klik Next</li>
                        <li>Cek Kode Verifikasi yang terkirim ke SMS</li>
                        <li>Masukan Kode Verifikasi</li>
                        <li>Masukan PIN DANA</li>
                        <li>Klik Pay</li>
                        <li>Klik Continue</li>
                        <li>Anda akan diredirect ke halaman Invoice dan diminta menunggu 5-30 Detik</li>
                        <li>Selesai</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'indodana'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran Indodana</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                        <li>Pilih Tenor</li>
                        <li>Klik Submit</li>
                        <li>Masuk akun Indodana (atau daftar jika belum mempunyai)</li>
                        <li>Klik Bayar</li>
                        <li>Masukan PIN Indodana</li>
                        <li>Klik Bayar</li>
                        <li>Klik Kembali ke Home</li>
                        <li>Anda akan diredirect ke halaman Invoice dan diminta menunggu 5-30 Detik</li>
                        <li>Selesai</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'veritransindomaret'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran Indomaret</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                        <li>Klik Proceed to Payment</li>
                        <li>Klik Continue</li>
                        <li>Klik Pay Now</li>
                        <li>Catat payment code/Kode Pembayaran yang muncul</li>
                        <li>Klik Continue Payment at Indomaret</li>
                        <li>Kunjungi Indomaret Terdekat</li>
                        <li>Informasikan Kode Pembayaran ke kasir untuk pembayaran Merchant Qwords</li>
                        <li>Selesaikan pembayaran</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'hanabankva'}
            <br><center><strong><p>No Virtual Account Hana Bank:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Hana Bank VA</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Hana Bank</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Pembayaran</li>
                        <li>Pilih Lainnya</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
            {elseif $InvoicePaymentMethod == 'hanabankvad'}
            <br><center><strong><p>No Virtual Account Hana Bank:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Hana Bank VA</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Hana Bank</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Pembayaran</li>
                        <li>Pilih Lainnya</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
            {elseif $InvoicePaymentMethod == 'danamonva'}
            <br><center><strong><p>No Virtual Account Danamon:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Danamon VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Danamon</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Pembayaran -> Lainnya -> Virtual Account</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
            {elseif $InvoicePaymentMethod == 'danamonvad'}
            <br><center><strong><p>No Virtual Account Danamon:<br><input type="text" value="{$nova}" id="myInput"> <button onclick="copytext()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
			<center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Danamon VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Danamon</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Pembayaran -> Lainnya -> Virtual Account</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
                        <li>Masukkan Nomor Virtual Account <b><span>{$nova}</span></b></li>
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
            {elseif $InvoicePaymentMethod == 'bjbva'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BJB VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM BJB</h3>
            		<div>
                		<ol>
                        <li>Pilih Menu Transaksi Lainnya</li>
                        <li>Pilih Virtual Account</li>
                        <li>Pilih Rekening Debet yang akan Digunakan</li>
                        <li>Input Virtual Account Number <b><span>{$nova}</span></b></li>
                        <li>Konfirmasi Detail transaksi Anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Internet Banking BJB</h3>
            		<div>
            			<ol>
                        <li>Login Internet Banking</li>
                        <li>Pilih Virtual Account</li>
                        <li>Pilih Rekening Debet yang akan Digunakan</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
                        <li>Konfirmasi Detail transaksi Anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Mobile Banking BJB</h3>
            		<div>
                	    <ol>
                        <li>Login Mobiile Banking</li>
                        <li>Pilih Virtual Account</li>
                        <li>Pilih Rekening Debet yang akan Digunakan</li>
                        <li>Input Nomor Virtual Account <b><span>{$nova}</span></b></li>
                        <li>Konfirmasi Detail transaksi Anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'sinarmasva'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Sinarmas VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM Sinarmas</h3>
            		<div>
                		<ol>
                        <li>Masukkan kartu ATM dan pilih bahasa</li>
                        <li>Lalu masukkan PIN kartu</li>
                        <li>Pilih menu pembayaran</li>
                        <li>Pilih menu berikutnya</li>
                        <li>Pilih menu Virtual Account dan Masukkan nomor Virtual Account</li>
                        <li>Lalu akan muncul validasi transaksi, pilih ‘benar’</li>
                        <li>Masukkan nominal transaksi</li>
                        <li>Lalu pilih ‘benar’</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Mobile Banking Sinarmas</h3>
            		<div>
                	    <ol>
                        <li>Log in pada aplikasi Simobi Plus</li>
                        <li>Masukkan User Name dan Password atau EasyPIN</li>
                        <li>Pilih menu Pay/Bayar</li>
                        <li>Pilih Virtual Account</li>
                        <li>Masukkan nomor Virtual Account Bank Sinarmas atau pilih dari<br />daftar pembayaran</li>
                        <li>Masukkan jumlah yang inginkan</li>
                        <li>Validasi tujuan dari transaksi</li>
                        <li>Masukkan easyPIN</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            		
            		<h3>Internet Banking Sinarmas</h3>
            		<div>
            			<ol>
                        <li>Login website www.banksinarmas.com</li>
                        <li>Pilih menu Pembayaran/Pembelian</li>
                        <li>Pada nama Biller, pilih Virtual Account</li>
                        <li>Pada menu IDPEL, masukka nomor Virtual Account</li>
                        <li>Lalu akan muncul validasi transaksi</li>
                        <li>Masukkan jumlah yang inginkan</li>
                        <li>Pilih ‘kirim’, masukkan OTP</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'oy'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BTPN VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>Jenius App</h3>
            		<div>
                		<ol>
                        <li>Buka menu "Send It"</li>
                        <li>Klik "Tambah Penerima"</li>
                        <li>Pilih bank tujuan "BTPN"</li>
                        <li>Masukkan nomor rekening virtual diatas dan klik "Lanjut"</li>
                        <li>Masukkan jumlah nominal diatas</li>
                        <li>Ikuti petunjuk hingga transaksi selesai</li>
                        </ol>
            		</div>
            
            		<h3>ATM BTPN VA</h3>
            		<div>
                	    <ol>
                        <li>Masukkan kartu debit/ATM Anda</li>
                        <li>Masukkan PIN Anda</li>
                        <li>Pilih "Menu Lain"</li>
                        <li>Pilih "Transfer"</li>
                        <li>Pilih "Rekening Nasabah Lain di BTPN"</li>
                        <li>Input nomor VA sebagai nomor rekening tujuan</li>
                        <li>Periksa detil transaksi pada layar ATM</li>
                        <li>Jika sudah sesuai, konfirmasi transaksi Anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            		
            		<h3>Phone (Khusus nasabah BTPN WOW!)</h3>
            		<div>
            			<ol>
                        <li>Telepon *247#</li>
                        <li>Masukkan PIN BTPN Wow! Anda dan kirim</li>
                        <li>Ketik 99 (untuk ke Menu Utama) dan kirim</li>
                        <li>Ketik 4 (untuk ke menu Kirim Uang) dan kirim</li>
                        <li>Ketik 4 (untuk ke menu Rekening Virtual) dan kirim</li>
                        <li>Masukkan nomor tujuan rekening virtual dan kirim</li>
                        <li>Masukkan jumlah pengiriman uang dan kirim</li>
                        <li>Ketik PIN BTPN Wow! untuk konfirmasi transaksi</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            		<h3>Tunai via Agen (Khusus nasabah BTPN WOW!)</h3>
            		<div>
            			<ol>
                        <li>Kunjungi Agen BTPN Wow! terdekat dengan membawa uang tunai yang akan dikirimkan</li>
                        <li>Informasikan nomor rekening virtual tujuan dan nominal yang akan dikirimkan ke Agen BTPN Wow!</li>
                        <li>Serahkan uang tunai ke Agen BTPN Wow!</li>
                        <li>Agen BTPN Wow! akan memproses transaksi Anda melalui aplikasi/sistem agen BTPN Wow!</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'bankdkiva'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran Bank DKI VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM</h3>
            		<div>
                		<ol>
                        <li>Masuk ke menu utama ATM Bank DKI</li>
                        <li>Pilih menu Pembayaran</li>
                        <li>Pilih menu Virtual Account</li>
                        <li>Masukan kode Virtual Account No Kode Verifikasi VA = 995014...</li>
                        <li>Masukan Kode pembayaran (Boleh diKosongkan)</li>
                        <li>Verifikasi kebenaran data jika sesuai tekan Benar Jika tidak tekan Salah</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Mobile Banking/JakOne Mobile</h3>
            		<div>
                	    <ol>
                        <li>Masuk ke menu utama JakOne Mobile Bank DKI</li>
                        <li>Pilih menu Pembayaran</li>
                        <li>Pilih menu Virtual Account</li>
                        <li>Masukan kode Virtual Account No Kode Verifikasi VA = 995014...</li>
                        <li>Masukan PIN</li>
                        <li>Konfirmasi tagihan pembayaran jika sesuai tekan Lanjut</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            		
            		<h3>MPOS</h3>
            		<div>
            			<ol>
                        <li>Masuk ke menu utama MPOS bank DKI</li>
                        <li>Pilih menu pembayaran VA</li>
                        <li>Masukan kode Virtual Account No Kode Verifikasi VA = 995014...</li>
                        <li>Konfirmasi tagihan pembayaran jika sesuai tekan Lanjut</li>
                        <li>Masukan Kartu</li>
                        <li>Masukan PIN</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            		<h3>CMS</h3>
            		<div>
            			<ol>
                        <li>Masuk ke menu utama CMS Bank DKI</li>
                        <li>Pilih menu pembayaran tagihan</li>
                        <li>Masukan kode Virtual Account No Kode Verifikasi VA = 995014...</li>
                        <li>Masuk ke menu utama user Approval</li>
                        <li>Pilih menu Tugas Tertunda</li>
                        <li>Cek Daftar Tugas Tertunda</li>
                        <li>Jika Sesuai pilih Menyetujui Jika tidak sesuai pilih Tolak</li>
                        <li>Konfirmasi Tagihan</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            		<h3>EDC</h3>
            		<div>
            			<ol>
                        <li>Masuk ke menu utama EDC Bank DKI</li>
                        <li>Pilih menu pembayaran VA</li>
                        <li>Pilih Jenis Rekening</li>
                        <li>Masukan kode Virtual Account No Kode Verifikasi VA = 995014...</li>
                        <li>Masukan PIN</li>
                        <li>Konfirmasi tagihan pembayaran jika sesuai tekan Lanjut</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'bsiva'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BSI VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller/Transfer Antar Bank</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>ATM BSI</h3>
            		<div>
                		<ol>
                        <li>Pilih Pembayaran/Pembelian</li>
                        <li>Pilih Institusi</li>
                        <li>Input Virtual Account Number <b><span>{$nova}</span></b></li>
                        <li>Detail yang ditampilkan: NIM, Nama, & Total Tagihan</li>
                        <li>Konfirmasi Detail transaksi Anda</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Internet Banking BSI</h3>
            		<div>
            			<ol>
                        <li>Login Internet Banking BSI</li>
                        <li>Pilih Pembayaran</li>
                        <li>Pilih Nomor Rekening BSI Anda</li>
                        <li>Pilih Institusi</li>
                        <li>Masukkan nama institusi Xendit (kode 9347)</li>
                        <li>Input Nomor Virtual Account tanpa 4 digit pertama atau kode institusi</li>
                        <li>Konfirmasi Detail transaksi Anda</li>
                        <li>Masukan Otentikasi Transaksi/Token</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Mobile Banking BSI</h3>
            		<div>
                	    <ol>
                        <li>Login Mobile Banking</li>
                        <li>Pilih Pembayaran</li>
                        <li>Pilih Nomor Rekening BSI Anda</li>
                        <li>Pilih Institusi</li>
                        <li>Masukkan nama institusi Xendit (kode 9347)</li>
                        <li>Input Nomor Virtual Account tanpa 4 digit pertama atau kode institusi</li>
                        <li>Konfirmasi Detail transaksi Anda</li>
                        <li>Masukan Otentikasi Transaksi/Token</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'bncva'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>
            <br><center><strong><p>Petunjuk Pembayaran BNC VA</p></strong></center>
            <br><font color="red"><center><strong><p>Metode ini bukan Untuk Pembayaran via Teller</p></strong></center></font>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <div class="accordion">
            		<h3>Internet Banking BNC</h3>
            		<div>
                		<ol>
                        <li>Login Aplikasi Neo Bank</li>
                        <li>Pilih Pembayaran VA</li>
                        <li>Pilih BNC</li>
                        <li>Input Nomor Virtual Account</li>
                        <li>Masukan Nominal Pembayaran sesuai Invoice yang terakhir di Klik Tombol Bayar Sekarang</li>
                        <li>Konfirmasi Informasi Pembayaran</li>
                        <li>Masukkan PIN</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            		<h3>Dari Bank Lain</h3>
            		<div>
            			<ol>
                        <li>Login ke Aplkasi Bank anda</li>
                        <li>Pilih Transfer ke bank lain</li>
                        <li>Pilih BNC</li>
                        <li>Input Nomor Virtual Account sebagai rekening penerima</li>
                        <li>Konfirmasi informasi transfer</li>
                        <li>Masukkan PIN</li>
                        <li>Selesai</li>
                        </ol>
            		</div>
            
            	</div>
                </td>  
            </tr> 
             </tbody>
            </table>
            {elseif $InvoicePaymentMethod == 'nicepayjeniuspay'}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <br><center><strong><p>Petunjuk Pembayaran</p></strong></center>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row">
                    <ol>
                    <li>Klik Pay Now</li>
                    <li>Masukan Cashtag Akun Jenius Personal Anda</li>
                    <li>Klik Submit</li>
                    <li>Notifikasi akan muncul di Smartphone Anda</li>
                    <li>Buka Notifikasi dan Lanjutkan Pembayaran</li>
                    <li>Selesai</li>
                    </ol>
                </td>  
            </tr> 
             </tbody>
            </table>
            {else}
            <center><strong><p>Total Tagihan:<br>IDR <input type="text" value="{$totalfixed}" id="myInput2"> <button onclick="copytext2()"><i class="fa fa-files-o" aria-hidden="true"></i></button><br></strong></center>

            <p>Mohon Lakukan Pembayaran secara PENUH ke:</p></br>
            <div class="table-responsive">
                <table class="table table-condensed">
            <tbody>
            <tr>
                <td class="total-row"><strong>PT Qwords Company International</strong></td>
                <td class="total-row"><strong>No Rekening</strong></td>
            </tr>
            <tr>
                <td class="total-row text-left">Bank Central Asia KC Wisma Mulia Jakarta</td>
                <td class="total-row">503-5778-770</td>
            </tr>
            <tr>
                <td class="total-row text-left">Bank Mandiri KC Suropati Bandung</td>
                <td class="total-row">131-00-12210-888</td>  
            </tr>
            </tbody>
            </table>
           
            {/if}

            
</div>


<br>
<br>
<p><b>{$LANG.infofakturpajakjudul}</b></p>
<p>{$LANG.infofakturpajak}</p>
<p>{$LANG.infofakturpajak2}</p>
<p>{$LANG.infofakturpajak3}</p>

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
                <a href="javascript:window.print()" class="btn btn-default"><i class="fa fa-print"></i> {$LANG.print}</a>
                <a href="dl.php?type=i&amp;id={$invoiceid}" class="btn btn-default"><i class="fa fa-download"></i> {$LANG.invoicesdownload}</a>
            </div>

        {/if}

    </div>
    
    
    <div id="modal_loader" style="position: fixed;top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 999;  display: none; justify-content: center; align-items: center;" >
        <div id="loader" style="background-color: #fff; padding: 20px; border-radius: 8px; z-index: 1000;">
            <img class="load" src="https://portal.qwords.com/modules/addons/addonmodule/load.webp" width="40px" height="43px"/>
            <h5 style="margin-left:15px" id="content-loader">Sedang memasukkan poin, mohon tunggu...</h5>
        </div>
    </div>
    
    <div id="modalDeleteItem" class="modal">
        <!-- Modal content -->
        <div class="modal-custom">
            <div class="modal-header-custom">
                <p>Delete Invoice Item</p>
                <span class="close" onclick="closeModal('modalDeleteItem')">&times;</span>
            </div>
            <div class="modal-content-custom">
                <p>Apakah Anda yakin akan menghapus item ini?</p>
            </div>
            <div class="modal-footer-custom">
                <button class="btn btn-secondary" onclick="closeModal('modalDeleteItem')">Cancel</button>
                <button class="btn btn-primary" id="delete-button" onclick="deleteItem()">Yes</button>
            </div>
        </div>
    </div>
    
    <div id="modalSplitItem" class="modal">
        <!-- Modal content -->
        <div class="modal-custom">
            <div class="modal-header-custom">
                <p>Split Invoice Item</p>
                <span class="close" onclick="closeModal('modalSplitItem')">&times;</span>
            </div>
            <div class="modal-content-custom">
                <p>Apakah Anda yakin akan meng-split item ini?</p>
            </div>
            <div class="modal-footer-custom">
                <button class="btn btn-secondary" onclick="closeModal('modalSplitItem')">Cancel</button>
                <button class="btn btn-primary" id="split-button" onclick="splitItem()">Yes</button>
            </div>
        </div>
    </div>

    <p class="text-center hidden-print"><a href="clientarea.php">{$LANG.invoicesbacktoclientarea}</a></a></p>
    <script src="templates/{$template}/js/accordion.js"></script>
    <script>
        document.querySelector('[value="xenditakulaku"]').style.display = 'none';
    </script>
    <script src="templates/{$template}/js/modal.js"></script>
</body>
</html>