Double_t x_start = 0;
Double_t y_start = 0;
Double_t side_length = 1;
Int_t n_x = 19; // should be odd
Int_t n_y = n_x; // should be odd, equal to n_x

void honeycomb() {

  TH2Poly *hc = new TH2Poly();
  TH2Poly *tri = new TH2Poly();
  TH2Poly *cnt = new TH2Poly();
  hc->Honeycomb(x_start,y_start,side_length,n_x,n_y);
  tri->Honeycomb(x_start,y_start,side_length,n_x,n_y);
  cnt->Honeycomb(x_start,y_start,side_length,n_x,n_y);
  Double_t xmin = hc->GetXaxis()->GetXmin();
  Double_t xmax = hc->GetXaxis()->GetXmax();
  Double_t ymin = hc->GetYaxis()->GetXmin();
  Double_t ymax = hc->GetYaxis()->GetXmax();

  printf("%.3f<x<%.3f\n%.3f<x<%.3f\n",xmin,xmax,ymin,ymax);

  Double_t cx,cy;
  Int_t row;
  Int_t c_lim,c_low,c_high;
  Int_t np_l,np_r,np;
  Int_t binn;

  // start
  Int_t mp = (n_x+1)/2;
  HexToCart(mp,n_y,cx,cy);
  hc->Fill(cx,cy,1);

  // iterate
  for(int r=n_y-1; r>0; r--) {
    row = n_y - r + 1;
    c_low = mp - row/2;
    c_high = mp + (row-1)/2;
    for(int c=c_low; c<=c_high; c++) {
      // left summand
      HexToCart(row%2==1?c-1:c, r+1, cx, cy);
      binn = hc->FindBin(cx,cy);
      np_l = hc->GetBinContent(binn);
      // right summand
      HexToCart(row%2==1?c:c+1, r+1, cx, cy);
      binn = hc->FindBin(cx,cy);
      np_r = hc->GetBinContent(binn);
      // sum
      np = np_l + np_r;
      HexToCart(c,r,cx,cy);
      hc->Fill(cx,cy,np);
      if(np%(row-1)) tri->Fill(cx,cy,1);
      else tri->Fill(cx,cy,2);
      if(c==c_low+1 || c==c_high-1) cnt->Fill(cx,cy,np);
    };
  };

  gStyle->SetOptStat(0);
  hc->SetTitle("pascal");
  tri->SetTitle("pascal");
  cnt->SetTitle("pascal");
  tri->Draw("AHCOL");
  hc->Draw("textsame");
  cnt->Draw("AHTEXTSAME");
}

void HexToCart(Int_t hx_,Int_t hy_,Double_t & cx_,Double_t & cy_) {
  Double_t s3 = TMath::Sqrt(3);
  cx_ = side_length*s3/2 * (hy_%2==0?2:1) + (hx_-1)*side_length*s3;
  cy_ = side_length + (hy_-1)*3.0*side_length/2.0;
};
