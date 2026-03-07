import PaymentMethodRadio from "components/PaymentMethodRadio";
import PreviousPageButton from "components/PreviousPageButton";
import SearchPaymentMethod from "components/SearchPaymentMethod";
// import OrderStep from 'layouts/OrderStep'
import {
  addPaymentMethod,
  addConvenienceFee,
} from "features/common/layouts/cartSlice";
import { paymentList } from "helpers/paymentmethod";
import MainLayouts from "layouts/MainLayouts";
import { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";

// Helper function to render payment methods
const renderPaymentMethods = (paymentList, handler, data, typePayment = null) => {
  return paymentList.map((vaItem) => (
    <PaymentMethodRadio
      key={vaItem.id}
      name="paymentMethod"
      value={vaItem.value}
      label={vaItem.label}
      icon={vaItem.icon}
      handler={handler}
      data={data}
      fee={vaItem.fee}
      add={vaItem.add}
      feetype={vaItem.feetype}
      typePayment={typePayment}
    />
  ));
};

// New AccordionItem component
const AccordionItem = ({ id, title, children, isExpanded = false }) => (
  <div className="accordion-item">
    <h2 className="accordion-header" id={`flush-${id}`}>
      <button
        className={`accordion-button ${isExpanded ? '' : 'collapsed'}`}
        type="button"
        data-bs-toggle="collapse"
        data-bs-target={`#flush-payment-${id}`}
        aria-expanded={isExpanded}
        aria-controls={`flush-payment-${id}`}
      >
        <h6 className="fw-bold">{title}</h6>
      </button>
    </h2>
    <div
      id={`flush-payment-${id}`}
      className={`accordion-collapse collapse ${isExpanded ? 'show' : ''}`}
      aria-labelledby={`flush-${id}`}
    >
      <div className="accordion-body px-5">{children}</div>
    </div>
  </div>
);

const PaymentMethod = () => {
  const dispatch = useDispatch();
  const { data_login } = useSelector((state) => state.auth);
  const { paymentMethod, subtotal } = useSelector((state) => state.cart);
  const { productsList } = useSelector((state) => state.cart);
  const [filteredPayment, setFilteredPayment] = useState(null);
  const [isNotID, setIsNotID] = useState(false);
  const [hasSetDefault, setHasSetDefault] = useState(false);
  const [expandedAccordion, setExpandedAccordion] = useState("3"); // Default to Bank Transfer accordion
  
  // Tambahkan pengecekan untuk domain dengan subtotal > 2jt
  const hasDomainAbove2M = productsList.some(item => 
    (item.type === "register" || item.type === "transfer" || item.type === "backorder-register" || item.type === "backorder") && 
    item.price > 2000000
  );

  // Check if Kemerdekaan promo is active (17-18 Agustus 2025)
  const kemerdekaanStartDate = new Date("2025-08-17T00:00:00+07:00");
  const kemerdekaanEndDate = new Date("2025-08-18T23:59:59+07:00");
  const currentDate = new Date();
  const isKemerdekaanPromoActive = currentDate >= kemerdekaanStartDate && currentDate <= kemerdekaanEndDate;

  // Check if cart contains .id domains
  const hasIdDomains = productsList.some(item => 
    (item.type === "register" || item.type === "transfer") && 
    item.domain && item.domain.endsWith(".id")
  );

  // Hide VA and QRIS during Kemerdekaan promo for .id domains
  const showVASection = subtotal <= 5000000 && !hasDomainAbove2M && !(isKemerdekaanPromoActive && hasIdDomains);
  const showQRISSection = subtotal <= 5000000 && !hasDomainAbove2M && !(isKemerdekaanPromoActive && hasIdDomains);
  
  // Hide BCA VA specifically during Kemerdekaan promo
  const showBCAVA = !(isKemerdekaanPromoActive && hasIdDomains);

  const selectPaymentHandler = (e) => {
    // Reset hasSetDefault when user manually selects a payment method
    setHasSetDefault(true);
    
    // Update expanded accordion based on payment method type
    const paymentValue = e.target.value;
    const paymentTitle = e.target.title;
    
    // Determine which accordion to expand based on payment method
    if (paymentList.transferBankList.some(item => item.value === paymentValue)) {
      setExpandedAccordion("3"); // Bank Transfer
    } else if (paymentList.VAList.some(item => item.value === paymentValue)) {
      setExpandedAccordion("1"); // Virtual Account
    } else if (paymentList.eWalletList.some(item => item.value === paymentValue)) {
      setExpandedAccordion("2"); // E-Wallet
    } else if (paymentList.paylaterList.some(item => item.value === paymentValue)) {
      setExpandedAccordion("6"); // Paylater
    } else if (paymentList.storePaymentList.some(item => item.value === paymentValue)) {
      setExpandedAccordion("4"); // Store Payment
    } else if (paymentList.internationalPayment.some(item => item.value === paymentValue)) {
      setExpandedAccordion("5"); // International
    }
    
    const fee = e.target.attributes.fee.value;
    const feetype = e.target.attributes.feetype.value;
    const add = e.target.attributes.add.value;

    // console.log("fee", fee);
    // console.log("feetype", feetype);
    // console.log("add", add);

    const title = e.target.title;
    const paymentType = e.target.attributes.payment.value;
    const checkHosting = productsList.find(
      (list) => list.type === "hostingaccount"
    );
    const checkServer = productsList.find((list) => list.type === "ssl");
    let value;
    // const pidPromo = [1097, 1098, 1099];
    // console.log("e.target.value", e.target.value);
    switch (title) {
      case "Visa/Mastercard":
        value = "ipay88";
        break;
      case "Alfamart":
      case "Dan-Dan":
      case "Alfamidi":
      case "Alfaexpress":
        value = "duitku_varitel";
        break;
      default:
        value = e.target.value;
    }
    // } else if (
    //   title === "Alfamart" ||
    //   title === "Dan-Dan" ||
    //   title === "Alfamidi" ||
    //   title === "Alfaexpress"
    // ) {
    //   value = "alfamart";
    // } else {
    //   value = e.target.value;
    // }

    if (checkHosting) {
      if (paymentType === "VA") {
        const feeAmount = subtotal > 3500000 ? 2500 : 5000;
        dispatch(
          addConvenienceFee({
            label: e.target.title,
            price: feeAmount,
            name: "Convenience Fee",
            type: "Additional Fee",
            fee: "Additional Fee",
            feetype: feetype,
            add: 0,
          })
        );
        dispatch(
          addPaymentMethod({
            label: title,
            value: value,
            valueNewUser: value === "bsiva" ? value : value + "d",
          })
        );
      } else {
        dispatch(
          addConvenienceFee({
            label: e.target.title,
            price: fee,
            name: "Convenience Fee",
            type: "Additional Fee",
            fee: "Additional Fee",
            feetype: feetype,
            add: add,
          })
        );
        dispatch(
          addPaymentMethod({
            label: title,
            value: value,
          })
        );
      }
    } else {
      if (checkHosting || checkServer || subtotal >= 300000) {
        if (paymentType === "VA") {
          const feeAmount = subtotal > 3500000 ? 2500 : 5000;
          dispatch(
            addConvenienceFee({
              label: e.target.title,
              price: feeAmount,
              name: "Convenience Fee",
              type: "Additional Fee",
              fee: "Additional Fee",
              feetype: feetype,
              add: add,
            })
          );
          dispatch(
            addPaymentMethod({
              label: title,
              value: value,
              valueNewUser: value === "bsiva" ? value : value + "d",
            })
          );
        } else if (value === "paypal") {
          dispatch(
            addConvenienceFee({
              label: e.target.title,
              price: fee,
              name: "Convenience Fee",
              type: "Additional Fee",
              fee: "Additional Fee",
              feetype: feetype,
              add: add,
            })
          );
          dispatch(
            addPaymentMethod({
              label: title,
              value: value,
            })
          );
        } else {
          dispatch(
            addConvenienceFee({
              label: e.target.title,
              price: fee,
              name: "Convenience Fee",
              type: "Additional Fee",
              fee: "Additional Fee",
              feetype: feetype,
              add: add,
            })
          );
          dispatch(
            addPaymentMethod({
              label: title,
              value: value,
            })
          );
        }
      } else {
        if (paymentType === "VA") {
          const feeAmount = subtotal > 3500000 ? 2500 : 5000;
          dispatch(
            addConvenienceFee({
              label: e.target.title,
              price: feeAmount,
              name: "Convenience Fee",
              type: "Additional Fee",
              fee: "Additional Fee",
              feetype: feetype,
              add: add,
            })
          );
          dispatch(
            addPaymentMethod({
              label: title,
              value: value,
              valueNewUser: value === "bsiva" ? value : value + "d",
            })
          );
        } else {
          dispatch(
            addConvenienceFee({
              label: e.target.title,
              price: fee,
              name: "Convenience Fee",
              type: "Additional Fee",
              fee: "Additional Fee",
              feetype: feetype,
              add: add,
            })
          );
          dispatch(
            addPaymentMethod({
              label: title,
              value: value,
            })
          );
        }
      }
    }
  };

  const filterPaymentMethods = (paymentList) => {
    if (data_login && data_login.client && data_login.client.country === "ID") {
      return paymentList.filter(
        (method) => method.value !== "stripe" && method.value !== "wise"
      );
    }
    return paymentList;
  };

  useEffect(() => {
    if (data_login && data_login.client && data_login.client.country) {
      if (data_login.client.country !== "ID") {
        setIsNotID(true);
      } else {
        setIsNotID(false);
      }
    }
  }, [data_login]);

  // Set default payment method to Bank Transfer BCA if no payment method is selected
  useEffect(() => {
    if (!paymentMethod?.value && !isNotID && !hasSetDefault) {
      // Set default payment method to Bank Transfer BCA
      dispatch(
        addPaymentMethod({
          label: "Transfer Bank BCA",
          value: "bcaapi",
        })
      );
      
      // No convenience fee for bank transfer
      dispatch(
        addConvenienceFee({
          label: "Transfer Bank BCA",
          price: 0,
          name: "Convenience Fee",
          type: "Additional Fee",
          fee: "Additional Fee",
          feetype: "fixed",
          add: 0,
        })
      );
      
      setHasSetDefault(true);
      
      // Auto-expand Bank Transfer accordion since default is Bank Transfer BCA
      setExpandedAccordion("3");
    }
  }, [paymentMethod, isNotID, hasSetDefault, dispatch, showVASection]);

  useEffect(() => {
    if (
      ((data_login && data_login.client && data_login.client.country === "ID") || filteredPayment) &&
      (paymentMethod?.value === "stripe" || paymentMethod?.value === "wise")
    ) {
      // Dispatch the action to update the payment method
      dispatch(
        addPaymentMethod({
          label: "Visa/Mastercard",
          value: "ipay88",
        })
      );
      // Dispatch the action to add the convenience fee
      dispatch(
        addConvenienceFee({
          label: "Visa/Mastercard",
          price: 0.031,
          name: "Convenience Fee",
          type: "Additional Fee",
          fee: "Additional Fee",
          feetype: "percent and fee",
          add: 3000,
        })
      );
    }
  }, [paymentMethod, data_login, filteredPayment, dispatch]);

  return (
    <div>
      <MainLayouts summary={false}>
        <div className="container-lg-fluid px-0">
          <PreviousPageButton />
          

          {/* <div className="row justify-content-center d-lg-none d-block">
						<div className="col-12 col-md-12 col-lg-12 col-xl-8">
							<OrderStep />
						</div>
					</div> */}
          {!isNotID ? (
            <>
              <SearchPaymentMethod
                paymentMethod={paymentList}
                setFilteredPayment={setFilteredPayment}
              />
              {filteredPayment && (
                <div className="row">
                  <div className="col-12 col-sm-8 col-lg-8 col-xl-6">
                    {filteredPayment.map((item) => (
                      <div
                        className="border border-danger d-flex align-items-center mb-3 bg-white p-3 shadow-sm rounded-4"
                        key={item.id}
                      >
                        <PaymentMethodRadio
                          key={item.id}
                          name="paymentMethodFiltered"
                          value={item.value}
                          label={item.label}
                          icon={item.icon}
                          handler={selectPaymentHandler}
                          data={paymentMethod}
                          fee={item.fee}
                          add={item.add}
                          feetype={item.feetype}
                        />
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </>
          ) : (
            <></>
          )}
        </div>
        <div className="accordion accordion-flush" id="addOnAccordion">
          {isNotID ? (
            <AccordionItem id="5" title="International">
              {renderPaymentMethods(
                filterPaymentMethods(paymentList.internationalPayment),
                selectPaymentHandler,
                paymentMethod
              )}
            </AccordionItem>
          ) : (
            <>
              <AccordionItem 
                id="3" 
                title="Transfer Bank / Transfer Antar Bank / Setor Tunai"
                isExpanded={expandedAccordion === "3"}
              >
                {paymentList.transferBankList.map((vaItem, index) => (
                  <div key={vaItem.id}>
                    <PaymentMethodRadio
                      name="paymentMethod"
                      value={vaItem.value}
                      label={vaItem.label}
                      icon={vaItem.icon}
                      handler={selectPaymentHandler}
                      data={paymentMethod}
                      fee={vaItem.fee}
                      add={vaItem.add}
                      feetype={vaItem.feetype}
                      showInstantPaymentNote={index === 0}
                    />
                  </div>
                ))}
              </AccordionItem>
              
              {/* Hide entire VA accordion during Kemerdekaan promo */}
              {showVASection && (
              <AccordionItem 
                id="1" 
                title="Transfer Virtual Account"
                isExpanded={expandedAccordion === "1"}
              >
                  {/* BCA VA - hide during Kemerdekaan promo */}
                  {showBCAVA && paymentList.VAList.filter(item => item.label === "BCA Virtual Account").map((vaItem) => (
                  <PaymentMethodRadio
                    key={vaItem.id}
                    name="paymentMethod"
                    value={vaItem.value}
                    label={vaItem.label}
                    icon={vaItem.icon}
                    handler={selectPaymentHandler}
                    data={paymentMethod}
                    fee={vaItem.fee}
                    add={vaItem.add}
                    feetype={vaItem.feetype}
                    typePayment="VA"
                  />
                ))}
                {/* VA lainnya sesuai kondisi */}
                  {paymentList.VAList.filter(item => item.label !== "BCA Virtual Account").map((vaItem) => (
                  <PaymentMethodRadio
                    key={vaItem.id}
                    name="paymentMethod"
                    value={vaItem.value}
                    label={vaItem.label}
                    icon={vaItem.icon}
                    handler={selectPaymentHandler}
                    data={paymentMethod}
                    fee={vaItem.fee}
                    add={vaItem.add}
                    feetype={vaItem.feetype}
                    typePayment="VA"
                  />
                ))}
              </AccordionItem>
              )}
              {showQRISSection && (
                <AccordionItem 
                  id="2" 
                  title="Uang Elektronik, E-Wallet, QRIS"
                  isExpanded={expandedAccordion === "2"}
                >
                  {renderPaymentMethods(
                    paymentList.eWalletList,
                    selectPaymentHandler,
                    paymentMethod
                  )}
                </AccordionItem>
              )}
              <AccordionItem 
                id="6" 
                title="Kartu Kredit Indonesia / Paylater"
                isExpanded={expandedAccordion === "6"}
              >
                {renderPaymentMethods(
                  paymentList.paylaterList,
                  selectPaymentHandler,
                  paymentMethod
                )}
              </AccordionItem>
              <AccordionItem 
                id="4" 
                title="Gerai Toko Ritel Terdekat"
                isExpanded={expandedAccordion === "4"}
              >
                {renderPaymentMethods(
                  paymentList.storePaymentList,
                  selectPaymentHandler,
                  paymentMethod
                )}
              </AccordionItem>
              <AccordionItem 
                id="5" 
                title="Credit Card International / International Payment"
                isExpanded={expandedAccordion === "5"}
              >
                {renderPaymentMethods(
                  filterPaymentMethods(paymentList.internationalPayment),
                  selectPaymentHandler,
                  paymentMethod
                )}
              </AccordionItem>
            </>
          )}
        </div>
      </MainLayouts>
    </div>
  );
};

export default PaymentMethod;
