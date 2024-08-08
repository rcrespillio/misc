
//+------------------------------------------------------------------+
//|                                               Ilan-TrioKS v1.47  |
//|                      Copyright © 2016, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
// Dec 15 -2011 -- Add Timer for Loop and print to screen
// Sep 12 - 2016 -- exposed time frame for ilan1.5
// Sep 16 - 2016 -- Bug fix: If OrderModify retruns false, routine goes into infinite loop, causing EA to hang indefinitely

#property copyright "Ilan-TrioKS v1.47 2016"
extern string t1 = "Happy Trading,    Sarah2018";
extern string t2 = "GENERAL SETTINGS";
extern double Lots = 0.01;            // ������ ����� � ��������� 0.01 ��� ���� ���� ����� 0.1 �� ��������� ��� � ����� ����� 0.16
extern double LotExponent = 1.55;     // ��������� ����� � ����� �� ���������� ��� ������ � ���������. ������ ��� 0.1, �����: 0.15, 0.26, 0.43 ...
extern int lotdecimal = 2;            // 2 - ��������� 0.01, 1 - ���� ���� 0.1, 0 - ���������� ���� 1.0
extern double PipStep = 30.0;         // ��� ������- ��� 30
extern double MaxLots = 100;          // ����������� ���� ����
extern bool MM = FALSE;               // �� - ��������������
extern double TakeProfit = 100.0;     // ���� ������
extern double Stoploss_16 = 40.0; // ��� ��� ��������� ��������!!!
extern bool UseEquityStop = false;    // ������������ ���� � ���������
extern double TotalEquityRisk = 20.0; // ���� � ��������� �� ��������
extern bool UseTrailingStop = FALSE;  // ������������ �������� ����
extern double TrailStart = 13.0;
extern double TrailStop = 3.0;
extern double slip = 5.0; // ���������������

//====================================================
//====================================================
extern string t3 = "Trading hours";
extern bool CloseFriday = true;  // использовать ограничение по времени в пятницу true, не использовать false
extern int CloseFridayHour = 17; // время в пятницу после которого не выставляется первый ордер
extern bool OpenMonday = true;   // использовать ограничение по времени в пятницу true, не использовать false
extern int OpenMondayHour = 10;  // время в пятницу после которого не выставляется первый ордер

//==============================================
//                 ILAN 1.6                                             //
//========================================================================
extern string t6 = "SETTINGS for Ilan 1.6 EA";
double LotExponent_16;
double Lots_16;
int lotdecimal_16;
double TakeProfit_16;
extern int MaxTrades_16 = 10;
bool UseEquityStop_16;     // ������������ ���� � ���������
double TotalEquityRisk_16; // ���� � ��������� �� ��������
int OpenNewTF_16 = PERIOD_H1;
//=========================================================
bool UseTrailingStop_16;
double TrailStart_16;
double TrailStop_16;
//=========================================================
bool UseTimeOut_16 = FALSE;
double MaxTradeOpenHours_16 = 48.0;
//=========================================================
double PipStep_16; // 30
double slip_16;
extern int ilanMagicNumber = 23794;
//=========================================================
double g_price_180_16;
double currentEquity;
double lastBuyPrice;
double currentBid;
double currentAsk;
double lastSellPrice;
double gd_244_16;
double gd_260_16;
string ilanLabel = "Ilan 1.6-KS";
int lastTradeTime = 0;
int gi_284_16;
int tradeCount = 0;
double normalizedLotSize;
int openPositionCount = 0;
int tradeSelectRetries;
bool gi_316_16 = FALSE;
bool isBuyTradeActive = FALSE;
bool isTimeoutActive = FALSE;
int orderTicket;
bool isStopTriggered = FALSE;
double gd_336_16;
double latestEquity;
datetime lastTimeFrame = 1;

//==============================
// ���������
//==============================
//==============================
string txt, txt1;
string txt2 = "";
string txt3 = "";
color col = ForestGreen;

//==============================
int init()

{
   return (INIT_SUCCEEDED);
}
int deinit()
{
   return (0);
}
//========================================================================
//========================================================================
int start()
{
   int counted_bars = IndicatorCounted();

   if (Lots > MaxLots)
      Lots = MaxLots; // ����������� �����
   {
      Comment("  BigGame24.tripod.com" + "\n" + "  Ilan-TrioKS v1.47" + "\n" + "____________________________________________________" + "\n" + "  Broker: " + AccountCompany() + "\n" + "  Brokers Time: " + TimeToStr(TimeCurrent(), TIME_DATE | TIME_SECONDS) + "\n" + "____________________________________________________" + "\n" + "  Name: " + AccountName() + "\n" + "  Account Number : " + AccountNumber() + "\n" + "  Account Currency: " + AccountCurrency() + "\n" + "____________________________________________________" + "\n" + "  Open Orders Ilan_1.6 : " + CountTrades_16() + "\n" + "  ALL ORDERS: " + OrdersTotal() + "\n" + "____________________________________________________" + "\n" + "  Account BALANCE: " + DoubleToStr(AccountBalance(), 2) + "\n" + "  Account EQUITY: " + DoubleToStr(AccountEquity(), 2) + "\n" + "  BigGame24.tripod.com");
   }
   {
      {
         //========================================================================//
         //                          CODE for Ilan 1.6 EA                          //
         //========================================================================//
         double l_iclose_8;
         double l_iclose_16;
         //=======================
         double LotExponent_16 = LotExponent;
         int lotdecimal_16 = lotdecimal;
         double TakeProfit_16 = TakeProfit;
         bool UseEquityStop_16 = UseEquityStop;
         double TotalEquityRisk_16 = TotalEquityRisk; // ���� � ��������� �� ��������
         bool UseTrailingStop_16 = UseTrailingStop;
         double TrailStart_16 = TrailStart;
         double TrailStop_16 = TrailStop;
         double PipStep_16 = PipStep; // 30
         double slip_16 = slip;       // ���������������
         //=======================
         // ��������������      //
         //=======================
         if (MM == true)
         {
            if (MathCeil(AccountBalance()) < 200000) // MM = ���� ���� ������ 200000, �� ��� = Lots (0.01), �����- % �� ����
            {
               double Lots_16 = Lots;
            }
            else
            {
               Lots_16 = 0.00001 * MathCeil(AccountBalance());
            }
         }
         else
            Lots_16 = Lots;

         //=======================
         if (UseTrailingStop_16)
            TrailingAlls_16(TrailStart_16, TrailStop_16, lastBuyPrice);
         if (UseTimeOut_16)
         {
            if (TimeCurrent() >= gi_284_16)
            {
               CloseThisSymbolAll_16();
               Print("Closed All due to TimeOut");
            }
         }
         if (lastTradeTime != Time[0])
         {
            lastTradeTime = Time[0];
            double ld_0_16 = CalculateProfit_16();
            if (UseEquityStop_16)
            {
               if (ld_0_16 < 0.0 && MathAbs(ld_0_16) > TotalEquityRisk_16 / 100.0 * AccountEquityHigh_16())
               {
                  CloseThisSymbolAll_16();
                  Print("Closed All due to Stop Out");
                  isStopTriggered = FALSE;
               }
            }
            tradeSelectRetries = CountTrades_16();
            if (tradeSelectRetries == 0)
               isBuyTradeActive = FALSE;
            for (openPositionCount = OrdersTotal() - 1; openPositionCount >= 0; openPositionCount--)
            {
               OrderSelect(openPositionCount, SELECT_BY_POS, MODE_TRADES);
               if (OrderSymbol() != Symbol() || OrderMagicNumber() != ilanMagicNumber)
                  continue;
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == ilanMagicNumber)
               {
                  if (OrderType() == OP_BUY)
                  {
                     isBuyTradeActive = TRUE;
                     isTimeoutActive = FALSE;
                     break;
                  }
               }
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == ilanMagicNumber)
               {
                  if (OrderType() == OP_SELL)
                  {
                     isBuyTradeActive = FALSE;
                     isTimeoutActive = TRUE;
                     break;
                  }
               }
            }
            if (tradeSelectRetries > 0 && tradeSelectRetries <= MaxTrades_16)
            {
               RefreshRates();
               lastSellPrice = FindLastBuyPrice_16();
               gd_244_16 = FindLastSellPrice_16();
               if (isBuyTradeActive && lastSellPrice - Ask >= PipStep_16 * Point)
                  gi_316_16 = TRUE;
               if (isTimeoutActive && Bid - gd_244_16 >= PipStep_16 * Point)
                  gi_316_16 = TRUE;
            }
            if (tradeSelectRetries < 1)
            {
               isTimeoutActive = FALSE;
               isBuyTradeActive = FALSE;
               //      gi_316_16 = TRUE;
               currentEquity = AccountEquity();
            }
            if (gi_316_16)
            {
               lastSellPrice = FindLastBuyPrice_16();
               gd_244_16 = FindLastSellPrice_16();
               if (isTimeoutActive)
               {
                  tradeCount = tradeSelectRetries;
                  normalizedLotSize = NormalizeDouble(Lots_16 * MathPow(LotExponent_16, tradeCount), lotdecimal_16);
                  RefreshRates();
                  orderTicket = OpenPendingOrder_16(1, normalizedLotSize, Bid, slip_16, Ask, Stoploss_16, TakeProfit_16, ilanLabel + "-" + tradeCount, ilanMagicNumber, 0);
                  if (orderTicket < 0)
                  {
                     Print("Error: ", GetLastError());
                     return (0);
                  }
                  gd_244_16 = FindLastSellPrice_16();
                  gi_316_16 = FALSE;
                  isStopTriggered = TRUE;
               }
               else
               {
                  if (isBuyTradeActive)
                  {
                     tradeCount = tradeSelectRetries;
                     normalizedLotSize = NormalizeDouble(Lots_16 * MathPow(LotExponent_16, tradeCount), lotdecimal_16);
                     orderTicket = OpenPendingOrder_16(0, normalizedLotSize, Ask, slip_16, Bid, Stoploss_16, TakeProfit_16, ilanLabel + "-" + tradeCount, ilanMagicNumber, 0);
                     if (orderTicket < 0)
                     {
                        Print("Error: ", GetLastError());
                        return (0);
                     }
                     lastSellPrice = FindLastBuyPrice_16();
                     gi_316_16 = FALSE;
                     isStopTriggered = TRUE;
                  }
               }
            }
         }
         if (lastTimeFrame != iTime(NULL, OpenNewTF_16, 0))
         {
            int totals_16 = OrdersTotal();
            int orders_16 = 0;
            for (int total_16 = totals_16; total_16 >= 1; total_16--)
            {
               OrderSelect(total_16 - 1, SELECT_BY_POS, MODE_TRADES);
               if (OrderSymbol() != Symbol() || OrderMagicNumber() != ilanMagicNumber)
                  continue;
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == ilanMagicNumber)
               {
                  orders_16++;
               }
            }
            if (totals_16 == 0 || orders_16 < 1)
            {
               l_iclose_8  = iClose(Symbol(), 0, 2);
               l_iclose_16  = iClose(Symbol(), 0, 1);
               currentBid = Bid;
               currentAsk = Ask;
               //      if (!isTimeoutActive && !isBuyTradeActive) {
               tradeCount = tradeSelectRetries;
               normalizedLotSize = /* NormalizeDouble(*/ Lots_16 /* * MathPow(LotExponent_16, tradeCount), lotdecimal_16)*/;
               if (l_iclose_8  > l_iclose_16)
               {
                  if (iRSI(NULL, PERIOD_H1, 14, PRICE_CLOSE, 1) > 30.0)
                  {
                     orderTicket = OpenPendingOrder_16(1, normalizedLotSize, currentBid, slip_16, currentBid, Stoploss_16, TakeProfit_16, ilanLabel + "-" + tradeCount, ilanMagicNumber, 0);
                     if (orderTicket < 0)
                     {
                        Print("Error: ", GetLastError());
                        return (0);
                     }
                     lastSellPrice = FindLastBuyPrice_16();
                     isStopTriggered = TRUE;
                  }
               }
               else
               {
                  if (iRSI(NULL, PERIOD_H1, 14, PRICE_CLOSE, 1) < 70.0)
                  {
                     orderTicket = OpenPendingOrder_16(0, normalizedLotSize, currentAsk, slip_16, currentAsk, Stoploss_16, TakeProfit_16, ilanLabel + "-" + tradeCount, ilanMagicNumber, 0);
                     if (orderTicket < 0)
                     {
                        Print("Error: ", GetLastError());
                        return (0);
                     }
                     gd_244_16 = FindLastSellPrice_16();
                     isStopTriggered = TRUE;
                  }
               }
               if (orderTicket > 0)
                  gi_284_16 = TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours_16);
               gi_316_16 = FALSE;
               //      }
            }
            lastTimeFrame = iTime(NULL, OpenNewTF_16, 0);
         }
         tradeSelectRetries = CountTrades_16();
         lastBuyPrice = 0;
         double ld_24_16 = 0;
         for (openPositionCount = OrdersTotal() - 1; openPositionCount >= 0; openPositionCount--)
         {
            OrderSelect(openPositionCount, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != ilanMagicNumber)
               continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == ilanMagicNumber)
            {
               if (OrderType() == OP_BUY || OrderType() == OP_SELL)
               {
                  lastBuyPrice += OrderOpenPrice() * OrderLots();
                  ld_24_16 += OrderLots();
               }
            }
         }
         if (tradeSelectRetries > 0)
            lastBuyPrice = NormalizeDouble(lastBuyPrice / ld_24_16, Digits);
      }
      //=============================
      return (0);
   }
}

   //==========================================================================
   //                       ODER FUNCTIONS for 1.6                           //
   //==========================================================================

   //============================================================//
   //======================CountTrades_16========================//
   //============================================================//
   int CountTrades_16()
   {
      int l_count_0_16 = 0;
      for (int l_pos_4_16 = OrdersTotal() - 1; l_pos_4_16 >= 0; l_pos_4_16--)
      {
         OrderSelect(l_pos_4_16, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != ilanMagicNumber)
            continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == ilanMagicNumber)
            if (OrderType() == OP_SELL || OrderType() == OP_BUY)
               l_count_0_16++;
      }
      return (l_count_0_16);
   }

   void CloseThisSymbolAll_16()
   {
      for (int l_pos_0_16 = OrdersTotal() - 1; l_pos_0_16 >= 0; l_pos_0_16--)
      {
         OrderSelect(l_pos_0_16, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == Symbol())
         {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == ilanMagicNumber)
            {
               if (OrderType() == OP_BUY)
                  OrderClose(OrderTicket(), OrderLots(), Bid, slip_16);
               if (OrderType() == OP_SELL)
                  OrderClose(OrderTicket(), OrderLots(), Ask, slip_16);
            }
            Sleep(1000);
         }
      }
   }

int OpenPendingOrder_16(int orderType, double lotSize, double price, int slippage, double stopLoss, int stopLossPips, int takeProfitPips, string orderComment, int magicNumber, int expirationTime)
{
   int orderTicket = 0;
   int errorCode = 0;
   int attemptCount = 0;
   int maxAttempts = 100;

   switch (orderType)
   {
   case 0: // Buy Order
      for (attemptCount = 0; attemptCount < maxAttempts; attemptCount++)
      {
         RefreshRates();
         orderTicket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, slippage, StopLong_16(Bid, stopLossPips), TakeLong_16(Ask, takeProfitPips), orderComment, magicNumber, expirationTime);
         errorCode = GetLastError();
         if (errorCode == 0) // NO_ERROR
            break;
         if (!(errorCode == 4 || errorCode == 137 || errorCode == 146 || errorCode == 136)) // SERVER_BUSY, BROKER_BUSY, TRADE_CONTEXT_BUSY, OFF_QUOTES
            break;
         Sleep(5000);
      }
      break;

   case 1: // Sell Order
      for (attemptCount = 0; attemptCount < maxAttempts; attemptCount++)
      {
         orderTicket = OrderSend(Symbol(), OP_SELL, lotSize, Bid, slippage, StopShort_16(Ask, stopLossPips), TakeShort_16(Bid, takeProfitPips), orderComment, magicNumber, expirationTime);
         errorCode = GetLastError();
         if (errorCode == 0) // NO_ERROR
            break;
         if (!(errorCode == 4 || errorCode == 137 || errorCode == 146 || errorCode == 136)) // SERVER_BUSY, BROKER_BUSY, TRADE_CONTEXT_BUSY, OFF_QUOTES
            break;
         Sleep(5000);
      }
   }

   return (orderTicket);
}

   double StopLong_16(double ad_0_16, int ai_8_16)
   {
      if (ai_8_16 == 0)
         return (0);
      else
         return (ad_0_16 - ai_8_16 * Point);
   }

   double StopShort_16(double ad_0_16, int ai_8_16)
   {
      if (ai_8_16 == 0)
         return (0);
      else
         return (ad_0_16 + ai_8_16 * Point);
   }

   double TakeLong_16(double ask, int ai_8_16)
   {
      if (ai_8_16 == 0)
         return (0);
      else
         return (ask + ai_8_16 * Point);
   }

   double TakeShort_16(double ad_0_16, int ai_8_16)
   {
      if (ai_8_16 == 0)
         return (0);
      else
         return (ad_0_16 - ai_8_16 * Point);
   }

   double CalculateProfit_16()
   {
      double ld_ret_0_16 = 0;
      for (openPositionCount = OrdersTotal() - 1; openPositionCount >= 0; openPositionCount--)
      {
         OrderSelect(openPositionCount, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != ilanMagicNumber)
            continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == ilanMagicNumber)
            if (OrderType() == OP_BUY || OrderType() == OP_SELL)
               ld_ret_0_16 += OrderProfit();
      }
      return (ld_ret_0_16);
   }

   void TrailingAlls_16(int ai_0_16, int ai_4_16, double a_price_8_16)
   {
      int l_ticket_16_16;
      double l_ord_stoploss_20_16;
      double l_price_28_16;
      if (ai_4_16 != 0)
      {
         for (int l_pos_36 = OrdersTotal() - 1; l_pos_36 >= 0; l_pos_36--)
         {
            if (OrderSelect(l_pos_36, SELECT_BY_POS, MODE_TRADES))
            {
               if (OrderSymbol() != Symbol() || OrderMagicNumber() != ilanMagicNumber)
                  continue;
               if (OrderSymbol() == Symbol() || OrderMagicNumber() == ilanMagicNumber)
               {
                  if (OrderType() == OP_BUY)
                  {
                     l_ticket_16_16 = NormalizeDouble((Bid - a_price_8_16) / Point, 0);
                     if (l_ticket_16_16 < ai_0_16)
                        continue;
                     l_ord_stoploss_20_16 = OrderStopLoss();
                     l_price_28_16 = Bid - ai_4_16 * Point;
                     if (l_ord_stoploss_20_16 == 0.0 || (l_ord_stoploss_20_16 != 0.0 && l_price_28_16 > l_ord_stoploss_20_16))
                        OrderModify(OrderTicket(), a_price_8_16, l_price_28_16, OrderTakeProfit(), 0);
                  }
                  if (OrderType() == OP_SELL)
                  {
                     l_ticket_16_16 = NormalizeDouble((a_price_8_16 - Ask) / Point, 0);
                     if (l_ticket_16_16 < ai_0_16)
                        continue;
                     l_ord_stoploss_20_16 = OrderStopLoss();
                     l_price_28_16 = Ask + ai_4_16 * Point;
                     if (l_ord_stoploss_20_16 == 0.0 || (l_ord_stoploss_20_16 != 0.0 && l_price_28_16 < l_ord_stoploss_20_16))
                        OrderModify(OrderTicket(), a_price_8_16, l_price_28_16, OrderTakeProfit(), 0);
                  }
               }
               Sleep(1000);
            }
         }
      }
   }

   double AccountEquityHigh_16()
   {
      if (CountTrades_16() == 0)
         gd_336_16 = AccountEquity();
      if (gd_336_16 < latestEquity)
         gd_336_16 = latestEquity;
      else
         gd_336_16 = AccountEquity();
      latestEquity = AccountEquity();
      return (gd_336_16);
   }

   double FindLastBuyPrice_16()
   {
      double l_ord_open_price_8_16;
      int l_ticket_24_16;
      double ld_unused_0_16 = 0;
      int l_ticket_20_16 = 0;
      for (int l_pos_16_16 = OrdersTotal() - 1; l_pos_16_16 >= 0; l_pos_16_16--)
      {
         OrderSelect(l_pos_16_16, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != ilanMagicNumber)
            continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == ilanMagicNumber && OrderType() == OP_BUY)
         {
            l_ticket_24_16 = OrderTicket();
            if (l_ticket_24_16 > l_ticket_20_16)
            {
               l_ord_open_price_8_16 = OrderOpenPrice();
               ld_unused_0_16 = l_ord_open_price_8_16;
               l_ticket_20_16 = l_ticket_24_16;
            }
         }
      }
      return (l_ord_open_price_8_16);
   }

   double FindLastSellPrice_16()
   {
      double l_ord_open_price_8_16;
      int l_ticket_24_16;
      double ld_unused_0_16 = 0;
      int l_ticket_20_16 = 0;
      for (int l_pos_16_16 = OrdersTotal() - 1; l_pos_16_16 >= 0; l_pos_16_16--)
      {
         OrderSelect(l_pos_16_16, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != ilanMagicNumber)
            continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == ilanMagicNumber && OrderType() == OP_SELL)
         {
            l_ticket_24_16 = OrderTicket();
            if (l_ticket_24_16 > l_ticket_20_16)
            {
               l_ord_open_price_8_16 = OrderOpenPrice();
               ld_unused_0_16 = l_ord_open_price_8_16;
               l_ticket_20_16 = l_ticket_24_16;
            }
         }
      }
      return (l_ord_open_price_8_16);
   }
