
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
int OpenNewTF_16 = 1;
//=========================================================
bool UseTrailingStop_16;
double Stoploss_16 = 40.0; // ��� ��� ��������� ��������!!!
double TrailStart_16;
double TrailStop_16;
//=========================================================
bool UseTimeOut_16 = FALSE;
double MaxTradeOpenHours_16 = 48.0;
//=========================================================
double PipStep_16; // 30
double slip_16;
extern int g_magic_176_16 = 23794;
//=========================================================
double g_price_180_16;
double gd_188_16;
double gd_unused_196_16;
double gd_unused_204_16;
double g_price_212_16;
double g_bid_220_16;
double g_ask_228_16;
double gd_236_16;
double gd_244_16;
double gd_260_16;
bool gi_268_16;
string gs_ilan_272_16 = "Ilan 1.6-KS";
int gi_280_16 = 0;
int gi_284_16;
int gi_288_16 = 0;
double gd_292_16;
int g_pos_300_16 = 0;
int gi_304_16;
double gd_308_16 = 0.0;
bool gi_316_16 = FALSE;
bool gi_320_16 = FALSE;
bool gi_324_16 = FALSE;
int gi_328_16;
bool gi_332_16 = FALSE;
double gd_336_16;
double gd_344_16;
datetime time_16 = 1;

//==============================
// ���������
//==============================
double gd_308;
int g_timeframe_492 = PERIOD_M1;
int g_timeframe_496 = PERIOD_M5;
int g_timeframe_500 = PERIOD_M15;
int g_timeframe_504 = PERIOD_M30;
int g_timeframe_508 = PERIOD_H1;
int g_timeframe_512 = PERIOD_H4;
int g_timeframe_516 = PERIOD_D1;
// string gs_unused_520 = "<<<< Chart Position Settings >>>>>";
bool g_corner_528 = TRUE;
int gi_532 = 0;
int gi_536 = 10;
int g_window_540 = 0;
// string gs_unused_544 = " <<<< Comments Settings >>>>>>>>";
bool gi_552 = TRUE;
bool gi_556 = TRUE;
bool gi_560 = FALSE;
int g_color_564 = Gray;
int g_color_568 = Gray;
int g_color_572 = Gray;
int g_color_576 = DarkOrange;
int g_color_580 = DarkOrange;
int gi_584 = 65280;
int gi_588 = 17919;
int gi_592 = 65280;
int gi_596 = 17919;
// string gs_unused_600 = " <<<< Price Color Settings >>>>>>>>";
int gi_608 = 65280;
int gi_612 = 255;
int gi_616 = 42495;
// string gs_unused_620 = "<<<< MACD Settings >>>>>>>>>>>";
int g_period_628 = 8;
int g_period_632 = 17;
int g_period_636 = 9;
int g_applied_price_640 = PRICE_CLOSE;
// string gs_unused_644 = "<<<< MACD Colors >>>>>>>>>>>>>>>>>>";
int gi_652 = 65280;
int gi_656 = 4678655;
int gi_660 = 32768;
int gi_664 = 255;
string gs_unused_668 = "<<<< STR Indicator Settings >>>>>>>>>>>>>";
string gs_unused_676 = "<<<< RSI Settings >>>>>>>>>>>>>";
int g_period_684 = 9;
int g_applied_price_688 = PRICE_CLOSE;
string gs_unused_692 = "<<<< CCI Settings >>>>>>>>>>>>>>";
int g_period_700 = 13;
int g_applied_price_704 = PRICE_CLOSE;
string gs_unused_708 = "<<<< STOCH Settings >>>>>>>>>>>";
int g_period_716 = 5;
int g_period_720 = 3;
int g_slowing_724 = 3;
int g_ma_method_728 = MODE_EMA;
string gs_unused_732 = "<<<< STR Colors >>>>>>>>>>>>>>>>";
int gi_740 = 65280;
int gi_744 = 255;
int gi_748 = 42495;
string gs_unused_752 = "<<<< MA Settings >>>>>>>>>>>>>>";
int g_period_760 = 5;
int g_period_764 = 9;
int g_ma_method_768 = MODE_EMA;
int g_applied_price_772 = PRICE_CLOSE;
string gs_unused_776 = "<<<< MA Colors >>>>>>>>>>>>>>";
int gi_784 = 65280;
int gi_788 = 255;
bool gi_792;
bool gi_796;
string gs_800;
double gd_808;
double g_acc_number_816;
double g_str2dbl_824;
double g_str_len_832;
double gd_848;
double gd_856;
double g_period_864;
double g_period_872;
double g_period_880;
double gd_888;
double gd_896;
double gd_904;
double gd_912;
double g_shift_920;
double gd_928;
double gd_936;
double gd_960;
double gd_968;
int g_bool_976;
double gd_980;
bool g_bool_988;
int gi_992;
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
            TrailingAlls_16(TrailStart_16, TrailStop_16, g_price_212_16);
         if (UseTimeOut_16)
         {
            if (TimeCurrent() >= gi_284_16)
            {
               CloseThisSymbolAll_16();
               Print("Closed All due to TimeOut");
            }
         }
         if (gi_280_16 != Time[0])
         {
            gi_280_16 = Time[0];
            double ld_0_16 = CalculateProfit_16();
            if (UseEquityStop_16)
            {
               if (ld_0_16 < 0.0 && MathAbs(ld_0_16) > TotalEquityRisk_16 / 100.0 * AccountEquityHigh_16())
               {
                  CloseThisSymbolAll_16();
                  Print("Closed All due to Stop Out");
                  gi_332_16 = FALSE;
               }
            }
            gi_304_16 = CountTrades_16();
            if (gi_304_16 == 0)
               gi_268_16 = FALSE;
            for (g_pos_300_16 = OrdersTotal() - 1; g_pos_300_16 >= 0; g_pos_300_16--)
            {
               OrderSelect(g_pos_300_16, SELECT_BY_POS, MODE_TRADES);
               if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16)
                  continue;
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16)
               {
                  if (OrderType() == OP_BUY)
                  {
                     gi_320_16 = TRUE;
                     gi_324_16 = FALSE;
                     break;
                  }
               }
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16)
               {
                  if (OrderType() == OP_SELL)
                  {
                     gi_320_16 = FALSE;
                     gi_324_16 = TRUE;
                     break;
                  }
               }
            }
            if (gi_304_16 > 0 && gi_304_16 <= MaxTrades_16)
            {
               RefreshRates();
               gd_236_16 = FindLastBuyPrice_16();
               gd_244_16 = FindLastSellPrice_16();
               if (gi_320_16 && gd_236_16 - Ask >= PipStep_16 * Point)
                  gi_316_16 = TRUE;
               if (gi_324_16 && Bid - gd_244_16 >= PipStep_16 * Point)
                  gi_316_16 = TRUE;
            }
            if (gi_304_16 < 1)
            {
               gi_324_16 = FALSE;
               gi_320_16 = FALSE;
               //      gi_316_16 = TRUE;
               gd_188_16 = AccountEquity();
            }
            if (gi_316_16)
            {
               gd_236_16 = FindLastBuyPrice_16();
               gd_244_16 = FindLastSellPrice_16();
               if (gi_324_16)
               {
                  gi_288_16 = gi_304_16;
                  gd_292_16 = NormalizeDouble(Lots_16 * MathPow(LotExponent_16, gi_288_16), lotdecimal_16);
                  RefreshRates();
                  gi_328_16 = OpenPendingOrder_16(1, gd_292_16, Bid, slip_16, Ask, 0, 0);
                  if (gi_328_16 < 0)
                  {
                     Print("Error: ", GetLastError());
                     return (0);
                  }
                  gd_244_16 = FindLastSellPrice_16();
                  gi_316_16 = FALSE;
                  gi_332_16 = TRUE;
               }
               else
               {
                  if (gi_320_16)
                  {
                     gi_288_16 = gi_304_16;
                     gd_292_16 = NormalizeDouble(Lots_16 * MathPow(LotExponent_16, gi_288_16), lotdecimal_16);
                     gi_328_16 = OpenPendingOrder_16(0, gd_292_16, Ask, slip_16, Bid, 0, 0);
                     if (gi_328_16 < 0)
                     {
                        Print("Error: ", GetLastError());
                        return (0);
                     }
                     gd_236_16 = FindLastBuyPrice_16();
                     gi_316_16 = FALSE;
                     gi_332_16 = TRUE;
                  }
               }
            }
         }
         if (time_16 != iTime(NULL, OpenNewTF_16, 0))
         {
            int totals_16 = OrdersTotal();
            int orders_16 = 0;
            for (int total_16 = totals_16; total_16 >= 1; total_16--)
            {
               OrderSelect(total_16 - 1, SELECT_BY_POS, MODE_TRADES);
               if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16)
                  continue;
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16)
               {
                  orders_16++;
               }
            }
            if (totals_16 == 0 || orders_16 < 1)
            {
               l_iclose_8 /*_16*/ = iClose(Symbol(), 0, 2);
               l_iclose_16 /*_16*/ = iClose(Symbol(), 0, 1);
               g_bid_220_16 = Bid;
               g_ask_228_16 = Ask;
               //      if (!gi_324_16 && !gi_320_16) {
               gi_288_16 = gi_304_16;
               gd_292_16 = /* NormalizeDouble(*/ Lots_16 /* * MathPow(LotExponent_16, gi_288_16), lotdecimal_16)*/;
               if (l_iclose_8 /*_16*/ > l_iclose_16 /*_16*/)
               {
                  if (iRSI(NULL, PERIOD_H1, 14, PRICE_CLOSE, 1) > 30.0)
                  {
                     gi_328_16 = OpenPendingOrder_16(1, gd_292_16, g_bid_220_16, slip_16, g_bid_220_16, 0, 0);
                     if (gi_328_16 < 0)
                     {
                        Print("Error: ", GetLastError());
                        return (0);
                     }
                     gd_236_16 = FindLastBuyPrice_16();
                     gi_332_16 = TRUE;
                  }
               }
               else
               {
                  if (iRSI(NULL, PERIOD_H1, 14, PRICE_CLOSE, 1) < 70.0)
                  {
                     gi_328_16 = OpenPendingOrder_16(0, gd_292_16, g_ask_228_16, slip_16, g_ask_228_16, 0, 0);
                     if (gi_328_16 < 0)
                     {
                        Print("Error: ", GetLastError());
                        return (0);
                     }
                     gd_244_16 = FindLastSellPrice_16();
                     gi_332_16 = TRUE;
                  }
               }
               if (gi_328_16 > 0)
                  gi_284_16 = TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours_16);
               gi_316_16 = FALSE;
               //      }
            }
            time_16 = iTime(NULL, OpenNewTF_16, 0);
         }
         gi_304_16 = CountTrades_16();
         g_price_212_16 = 0;
         double ld_24_16 = 0;
         for (g_pos_300_16 = OrdersTotal() - 1; g_pos_300_16 >= 0; g_pos_300_16--)
         {
            OrderSelect(g_pos_300_16, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16)
               continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16)
            {
               if (OrderType() == OP_BUY || OrderType() == OP_SELL)
               {
                  g_price_212_16 += OrderOpenPrice() * OrderLots();
                  ld_24_16 += OrderLots();
               }
            }
         }
         if (gi_304_16 > 0)
            g_price_212_16 = NormalizeDouble(g_price_212_16 / ld_24_16, Digits);
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
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16)
            continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16)
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
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16)
            {
               if (OrderType() == OP_BUY)
                  OrderClose(OrderTicket(), OrderLots(), Bid, slip_16, Blue);
               if (OrderType() == OP_SELL)
                  OrderClose(OrderTicket(), OrderLots(), Ask, slip_16, Red);
            }
            Sleep(1000);
         }
      }
   }

   int OpenPendingOrder_16(int ai_0_16, double a_lots_4_16, double a_price_12_16, int a_slippage_20_16, double ad_24_16, int ai_32_16, int ai_36_16)
   {
      int l_ticket_60_16 = 0;
      int l_error_64_16 = 0;
      int l_count_68_16 = 0;
      int li_72_16 = 100;
      switch (ai_0_16)
      {
      case 0:
         for (l_count_68_16 = 0; l_count_68_16 < li_72_16; l_count_68_16++)
         {
            RefreshRates();
            l_ticket_60_16 = OrderSend(Symbol(), OP_BUY, a_lots_4_16, Ask, a_slippage_20_16, StopLong_16(Bid, ai_32_16), TakeLong_16(Ask, ai_36_16));
            l_error_64_16 = GetLastError();
            if (l_error_64_16 == 0 /* NO_ERROR */)
               break;
            if (!(l_error_64_16 == 4 /* SERVER_BUSY */ || l_error_64_16 == 137 /* BROKER_BUSY */ || l_error_64_16 == 146 /* TRADE_CONTEXT_BUSY */ || l_error_64_16 == 136 /* OFF_QUOTES */))
               break;
            Sleep(5000);
         }
         break;
      case 1:
         for (l_count_68_16 = 0; l_count_68_16 < li_72_16; l_count_68_16++)
         {
            l_ticket_60_16 = OrderSend(Symbol(), OP_SELL, a_lots_4_16, Bid, a_slippage_20_16, StopShort_16(Ask, ai_32_16), TakeShort_16(Bid, ai_36_16));
            l_error_64_16 = GetLastError();
            if (l_error_64_16 == 0 /* NO_ERROR */)
               break;
            if (!(l_error_64_16 == 4 /* SERVER_BUSY */ || l_error_64_16 == 137 /* BROKER_BUSY */ || l_error_64_16 == 146 /* TRADE_CONTEXT_BUSY */ || l_error_64_16 == 136 /* OFF_QUOTES */))
               break;
            Sleep(5000);
         }
      }

      return (l_ticket_60_16);
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

   double TakeLong_16(double ad_0_16, int ai_8_16)
   {
      if (ai_8_16 == 0)
         return (0);
      else
         return (ad_0_16 + ai_8_16 * Point);
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
      for (g_pos_300_16 = OrdersTotal() - 1; g_pos_300_16 >= 0; g_pos_300_16--)
      {
         OrderSelect(g_pos_300_16, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16)
            continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16)
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
               if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16)
                  continue;
               if (OrderSymbol() == Symbol() || OrderMagicNumber() == g_magic_176_16)
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
      if (gd_336_16 < gd_344_16)
         gd_336_16 = gd_344_16;
      else
         gd_336_16 = AccountEquity();
      gd_344_16 = AccountEquity();
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
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16)
            continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16 && OrderType() == OP_BUY)
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
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16)
            continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16 && OrderType() == OP_SELL)
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
