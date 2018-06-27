//
//  LineChartViewController.swift
//  Cryptomarket
//
//  Created by Alex on 30.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import Charts

struct ChartCoDomainAxsis {
    let min: Double
    let max: Double
    let avg: Double
}

protocol LineChartViewDataSource: class {
    var lineChartView: LineChartView! { get }
    var animated: Bool { get }
    var chartDataEntries: [ChartDataEntry] { get }

    func balloonMarker() -> BalloonMarker?
    func chartLimitLine(for position: ChartLimitLine.LabelPosition) -> ChartLimitLine?
    func coDomainAxsisForZooming() -> ChartCoDomainAxsis?
}

// default
extension LineChartViewDataSource {
    func balloonMarker() -> BalloonMarker? { return nil }
    func chartLimitLine(for position: ChartLimitLine.LabelPosition) -> ChartLimitLine? { return nil }
    func coDomainAxsisForZooming() -> ChartCoDomainAxsis? { return nil }
}

class LineChartViewController: UIViewController {

    weak var dataSource: LineChartViewDataSource?

    private var _lineChartView: LineChartView {
        return dataSource!.lineChartView
    }

    private var values: [ChartDataEntry] {
        return dataSource!.chartDataEntries
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        assert(dataSource != nil, "dataSource must be set")

        setup(with: _lineChartView)
        showData(animated: dataSource!.animated)
    }

    private func setup(with lineChartView: LineChartView) {
        lineChartView.chartDescription?.enabled = false
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = true
        lineChartView.backgroundColor = .white
        lineChartView.legend.enabled = false

        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .topInside
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = .tintColor
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true

        let leftAxis = lineChartView.leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        leftAxis.labelTextColor = .tintColor

        lineChartView.rightAxis.enabled = false
        lineChartView.legend.form = .line

        drawBalloonMarker()
    }

    private func configure(chartLimitLine: ChartLimitLine, at position: ChartLimitLine.LabelPosition) -> ChartLimitLine {
        chartLimitLine.lineWidth = 4
        chartLimitLine.lineDashLengths = [5, 5]
        chartLimitLine.labelPosition = position
        chartLimitLine.valueFont = .systemFont(ofSize: 10)
        return chartLimitLine
    }

    private func drawBalloonMarker() {
        guard let marker = dataSource?.balloonMarker() else { return }

        marker.chartView = _lineChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        _lineChartView.marker = marker
    }

    private func drawlines() {
        if let botLine = dataSource?.chartLimitLine(for: .rightBottom) {
            _lineChartView.leftAxis.addLimitLine(configure(chartLimitLine: botLine, at: .rightBottom))
        }

        if let topLine = dataSource?.chartLimitLine(for: .rightTop) {
            _lineChartView.leftAxis.addLimitLine(configure(chartLimitLine: topLine, at: .rightTop))
        }
    }

    private func zoomIntoScope() {
        guard let scope = dataSource?.coDomainAxsisForZooming() else { return }

        let offset = scope.avg * 0.1
        _lineChartView.leftAxis.axisMinimum = scope.min - offset
        _lineChartView.leftAxis.axisMaximum = scope.max + offset
    }

    private func showData(animated: Bool) {
        let dataSet = LineChartDataSet(values: values, label: "DataSet 1")
        dataSet.axisDependency = .left
        dataSet.setColor(.coolGreen)
        dataSet.lineWidth = 1.5
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.fillAlpha = 0.26
        dataSet.fillColor = .coolGreen
        dataSet.highlightColor = .black
        dataSet.highlightLineWidth = 1.0
        dataSet.drawCircleHoleEnabled = false

        let data = LineChartData(dataSet: dataSet)
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))

        _lineChartView.data = data

        drawlines()
        zoomIntoScope()

        if animated { _lineChartView.animate(xAxisDuration: 1.0) }
    }
}


