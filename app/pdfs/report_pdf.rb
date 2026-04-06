class ReportPdf < Prawn::Document
  def initialize(events)
    super(top_margin: 70)
    @events = events
    pdf_header
    line_items
  end
  
  def pdf_header
    text "Event Report", size: 30, style: :bold
  end
  
  def line_items
    move_down 20
    table line_item_rows do
      row(0).font_style = :bold
      self.row_colors = ["FFFFFF", "C7F2FF"]
      self.header = true
    end
  end
  
  def line_item_rows
    [["Event Name", "Event Start Date", "Event End Date"]] +
    @events.map do |event|
      [event.name, event.start_at.to_date, event.end_at.to_date]
    end
  end
end