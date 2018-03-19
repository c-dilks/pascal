Double_t x_start = 0;
Double_t y_start = 0;
Double_t side_length = 1;
Double_t s3 = TMath::Sqrt(3);

void draw(Int_t n_x, TString divis) {

  //50 = random colors
  //51 = deep sea
  //52 = monochrome
  //53 = fire
  //54 = blue/yellow
  //55 = rainbow
  //56 = blackbody
  gStyle->SetPalette(55);

  TString infile_name = "data/triangle_"+divis+".dat";
  cout << "reading " << infile_name << endl;
  TTree * tr = new TTree();
  tr->ReadFile(infile_name.Data(),"hx/I:hy/I:st/F");
  Int_t hx,hy;
  Float_t st;
  tr->SetBranchAddress("hx",&hx);
  tr->SetBranchAddress("hy",&hy);
  tr->SetBranchAddress("st",&st);

  TH2Poly *hc = new TH2Poly();
  hc->Honeycomb(x_start,y_start,side_length,n_x,n_x);

  TString outfile_name = "data/picture_"+divis+".png";
  cout << outfile_name << endl;

  Double_t cx,cy;
  for(int x=0; x<tr->GetEntries(); x++) {
    tr->GetEntry(x);
    HexToCart(hx,hy,cx,cy);
    hc->Fill(cx,cy,st);
  };

  TCanvas * canv = new TCanvas("canv","canv",3000,3000);
  gStyle->SetOptStat(0);
  TString hcT = "pascal mod " + divis;
  hc->SetTitle(hcT.Data());
  hc->Draw("ahcolz");
  canv->Print(outfile_name.Data(),"png");
}

void HexToCart(Int_t hx_,Int_t hy_,Double_t & cx_,Double_t & cy_) {
  cx_ = side_length*s3/2 * (hy_%2==0?2:1) + (hx_-1)*side_length*s3;
  cy_ = side_length + (hy_-1)*3.0*side_length/2.0;
};
