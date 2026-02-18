#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: Fm Tx
# GNU Radio version: v3.9.2.0-85-g08bb05c1

from distutils.version import StrictVersion

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print("Warning: failed to XInitThreads()")

from PyQt5 import Qt
from gnuradio import qtgui
from gnuradio.filter import firdes
import sip
from gnuradio import analog
from gnuradio import blocks
import pmt
from gnuradio import filter
from gnuradio import gr
from gnuradio.fft import window
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio.qtgui import Range, RangeWidget
from PyQt5 import QtCore
import osmosdr
import time



from gnuradio import qtgui

class fm_tx(gr.top_block, Qt.QWidget):

    def __init__(self):
        gr.top_block.__init__(self, "Fm Tx", catch_exceptions=True)
        Qt.QWidget.__init__(self)
        self.setWindowTitle("Fm Tx")
        qtgui.util.check_set_qss()
        try:
            self.setWindowIcon(Qt.QIcon.fromTheme('gnuradio-grc'))
        except:
            pass
        self.top_scroll_layout = Qt.QVBoxLayout()
        self.setLayout(self.top_scroll_layout)
        self.top_scroll = Qt.QScrollArea()
        self.top_scroll.setFrameStyle(Qt.QFrame.NoFrame)
        self.top_scroll_layout.addWidget(self.top_scroll)
        self.top_scroll.setWidgetResizable(True)
        self.top_widget = Qt.QWidget()
        self.top_scroll.setWidget(self.top_widget)
        self.top_layout = Qt.QVBoxLayout(self.top_widget)
        self.top_grid_layout = Qt.QGridLayout()
        self.top_layout.addLayout(self.top_grid_layout)

        self.settings = Qt.QSettings("GNU Radio", "fm_tx")

        try:
            if StrictVersion(Qt.qVersion()) < StrictVersion("5.0.0"):
                self.restoreGeometry(self.settings.value("geometry").toByteArray())
            else:
                self.restoreGeometry(self.settings.value("geometry"))
        except:
            pass

        ##################################################
        # Variables
        ##################################################
        self.tx_rate = tx_rate = 2000000
        self.tx_freq = tx_freq = 94700000
        self.samp_rate = samp_rate = 48000
        self.rf_gain = rf_gain = 14
        self.mpx_rate = mpx_rate = 160000
        self.if_gain = if_gain = 40
        self.bb_gain = bb_gain = 20
        self.audio_gain = audio_gain = 0.00005

        ##################################################
        # Blocks
        ##################################################
        self._tx_freq_range = Range(87500000, 108000000, 100000, 94700000, 200)
        self._tx_freq_win = RangeWidget(self._tx_freq_range, self.set_tx_freq, 'tx_freq', "counter_slider", int, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._tx_freq_win)
        self._rf_gain_range = Range(0, 14, 1, 14, 200)
        self._rf_gain_win = RangeWidget(self._rf_gain_range, self.set_rf_gain, 'rf_gain', "dial", int, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._rf_gain_win)
        self._if_gain_range = Range(1, 40, 1, 40, 200)
        self._if_gain_win = RangeWidget(self._if_gain_range, self.set_if_gain, 'if_gain', "dial", int, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._if_gain_win)
        self._bb_gain_range = Range(1, 62, 1, 20, 200)
        self._bb_gain_win = RangeWidget(self._bb_gain_range, self.set_bb_gain, 'bb_gain', "dial", int, QtCore.Qt.Horizontal)
        self.top_layout.addWidget(self._bb_gain_win)
        self.rational_resampler_xxx_3 = filter.rational_resampler_ccf(
                interpolation=tx_rate,
                decimation=mpx_rate,
                taps=[],
                fractional_bw=0)
        self.rational_resampler_xxx_1 = filter.rational_resampler_fff(
                interpolation=mpx_rate,
                decimation=samp_rate,
                taps=[],
                fractional_bw=0)
        self.rational_resampler_xxx_0 = filter.rational_resampler_fff(
                interpolation=mpx_rate,
                decimation=samp_rate,
                taps=[],
                fractional_bw=0)
        self.qtgui_freq_sink_x_1 = qtgui.freq_sink_c(
            1024, #size
            window.WIN_BLACKMAN_hARRIS, #wintype
            0, #fc
            tx_rate, #bw
            "", #name
            1,
            None # parent
        )
        self.qtgui_freq_sink_x_1.set_update_time(0.10)
        self.qtgui_freq_sink_x_1.set_y_axis(-140, 10)
        self.qtgui_freq_sink_x_1.set_y_label('Relative Gain', 'dB')
        self.qtgui_freq_sink_x_1.set_trigger_mode(qtgui.TRIG_MODE_FREE, 0.0, 0, "")
        self.qtgui_freq_sink_x_1.enable_autoscale(True)
        self.qtgui_freq_sink_x_1.enable_grid(False)
        self.qtgui_freq_sink_x_1.set_fft_average(1.0)
        self.qtgui_freq_sink_x_1.enable_axis_labels(True)
        self.qtgui_freq_sink_x_1.enable_control_panel(False)
        self.qtgui_freq_sink_x_1.set_fft_window_normalized(False)



        labels = ['', '', '', '', '',
            '', '', '', '', '']
        widths = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]
        colors = ["blue", "red", "green", "black", "cyan",
            "magenta", "yellow", "dark red", "dark green", "dark blue"]
        alphas = [1.0, 1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0, 1.0]

        for i in range(1):
            if len(labels[i]) == 0:
                self.qtgui_freq_sink_x_1.set_line_label(i, "Data {0}".format(i))
            else:
                self.qtgui_freq_sink_x_1.set_line_label(i, labels[i])
            self.qtgui_freq_sink_x_1.set_line_width(i, widths[i])
            self.qtgui_freq_sink_x_1.set_line_color(i, colors[i])
            self.qtgui_freq_sink_x_1.set_line_alpha(i, alphas[i])

        self._qtgui_freq_sink_x_1_win = sip.wrapinstance(self.qtgui_freq_sink_x_1.pyqwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_freq_sink_x_1_win)
        self.qtgui_freq_sink_x_0 = qtgui.freq_sink_f(
            1024, #size
            window.WIN_BLACKMAN_hARRIS, #wintype
            0, #fc
            mpx_rate, #bw
            "", #name
            1,
            None # parent
        )
        self.qtgui_freq_sink_x_0.set_update_time(0.10)
        self.qtgui_freq_sink_x_0.set_y_axis(-140, 10)
        self.qtgui_freq_sink_x_0.set_y_label('Relative Gain', 'dB')
        self.qtgui_freq_sink_x_0.set_trigger_mode(qtgui.TRIG_MODE_FREE, 0.0, 0, "")
        self.qtgui_freq_sink_x_0.enable_autoscale(False)
        self.qtgui_freq_sink_x_0.enable_grid(False)
        self.qtgui_freq_sink_x_0.set_fft_average(1.0)
        self.qtgui_freq_sink_x_0.enable_axis_labels(True)
        self.qtgui_freq_sink_x_0.enable_control_panel(False)
        self.qtgui_freq_sink_x_0.set_fft_window_normalized(False)


        self.qtgui_freq_sink_x_0.set_plot_pos_half(not True)

        labels = ['', '', '', '', '',
            '', '', '', '', '']
        widths = [1, 1, 1, 1, 1,
            1, 1, 1, 1, 1]
        colors = ["blue", "red", "green", "black", "cyan",
            "magenta", "yellow", "dark red", "dark green", "dark blue"]
        alphas = [1.0, 1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0, 1.0]

        for i in range(1):
            if len(labels[i]) == 0:
                self.qtgui_freq_sink_x_0.set_line_label(i, "Data {0}".format(i))
            else:
                self.qtgui_freq_sink_x_0.set_line_label(i, labels[i])
            self.qtgui_freq_sink_x_0.set_line_width(i, widths[i])
            self.qtgui_freq_sink_x_0.set_line_color(i, colors[i])
            self.qtgui_freq_sink_x_0.set_line_alpha(i, alphas[i])

        self._qtgui_freq_sink_x_0_win = sip.wrapinstance(self.qtgui_freq_sink_x_0.pyqwidget(), Qt.QWidget)
        self.top_layout.addWidget(self._qtgui_freq_sink_x_0_win)
        self.osmosdr_sink_0 = osmosdr.sink(
            args="numchan=" + str(1) + " " + 'hackrf=0'
        )
        self.osmosdr_sink_0.set_time_unknown_pps(osmosdr.time_spec_t())
        self.osmosdr_sink_0.set_sample_rate(tx_rate)
        self.osmosdr_sink_0.set_center_freq(tx_freq, 0)
        self.osmosdr_sink_0.set_freq_corr(0, 0)
        self.osmosdr_sink_0.set_gain(rf_gain, 0)
        self.osmosdr_sink_0.set_if_gain(if_gain, 0)
        self.osmosdr_sink_0.set_bb_gain(bb_gain, 0)
        self.osmosdr_sink_0.set_antenna('', 0)
        self.osmosdr_sink_0.set_bandwidth(0, 0)
        self.low_pass_filter_0 = filter.fir_filter_fff(
            1,
            firdes.low_pass(
                1,
                mpx_rate,
                15000,
                2000,
                window.WIN_HANN,
                6.76))
        self.blocks_vector_to_streams_0 = blocks.vector_to_streams(gr.sizeof_short*1, 2)
        self.blocks_short_to_float_1 = blocks.short_to_float(1, 1)
        self.blocks_short_to_float_0 = blocks.short_to_float(1, 1)
        self.blocks_multiply_const_vxx_2 = blocks.multiply_const_cc(32768)
        self.blocks_multiply_const_vxx_1 = blocks.multiply_const_ff(audio_gain)
        self.blocks_multiply_const_vxx_0 = blocks.multiply_const_ff(audio_gain)
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_short*2, 'C:\\Users\\bcpmosaj\\OneDrive - UPV EHU\\0_2025.2026\\KSE\\Dev\\GNU_Radio\\oihu.wav', True, 0, 0)
        self.blocks_file_source_0.set_begin_tag(pmt.PMT_NIL)
        self.blocks_add_xx_0 = blocks.add_vff(1)
        self.analog_frequency_modulator_fc_0 = analog.frequency_modulator_fc(.980)
        self.analog_fm_preemph_1 = analog.fm_preemph(fs=samp_rate, tau=50e-6, fh=-1.0)
        self.analog_fm_preemph_0 = analog.fm_preemph(fs=samp_rate, tau=50e-6, fh=-1.0)



        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_fm_preemph_0, 0), (self.rational_resampler_xxx_0, 0))
        self.connect((self.analog_fm_preemph_1, 0), (self.rational_resampler_xxx_1, 0))
        self.connect((self.analog_frequency_modulator_fc_0, 0), (self.blocks_multiply_const_vxx_2, 0))
        self.connect((self.blocks_add_xx_0, 0), (self.low_pass_filter_0, 0))
        self.connect((self.blocks_file_source_0, 0), (self.blocks_vector_to_streams_0, 0))
        self.connect((self.blocks_multiply_const_vxx_0, 0), (self.analog_fm_preemph_0, 0))
        self.connect((self.blocks_multiply_const_vxx_1, 0), (self.analog_fm_preemph_1, 0))
        self.connect((self.blocks_multiply_const_vxx_2, 0), (self.rational_resampler_xxx_3, 0))
        self.connect((self.blocks_short_to_float_0, 0), (self.blocks_multiply_const_vxx_0, 0))
        self.connect((self.blocks_short_to_float_1, 0), (self.blocks_multiply_const_vxx_1, 0))
        self.connect((self.blocks_vector_to_streams_0, 0), (self.blocks_short_to_float_0, 0))
        self.connect((self.blocks_vector_to_streams_0, 1), (self.blocks_short_to_float_1, 0))
        self.connect((self.low_pass_filter_0, 0), (self.analog_frequency_modulator_fc_0, 0))
        self.connect((self.low_pass_filter_0, 0), (self.qtgui_freq_sink_x_0, 0))
        self.connect((self.rational_resampler_xxx_0, 0), (self.blocks_add_xx_0, 0))
        self.connect((self.rational_resampler_xxx_1, 0), (self.blocks_add_xx_0, 1))
        self.connect((self.rational_resampler_xxx_3, 0), (self.osmosdr_sink_0, 0))
        self.connect((self.rational_resampler_xxx_3, 0), (self.qtgui_freq_sink_x_1, 0))


    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "fm_tx")
        self.settings.setValue("geometry", self.saveGeometry())
        self.stop()
        self.wait()

        event.accept()

    def get_tx_rate(self):
        return self.tx_rate

    def set_tx_rate(self, tx_rate):
        self.tx_rate = tx_rate
        self.osmosdr_sink_0.set_sample_rate(self.tx_rate)
        self.qtgui_freq_sink_x_1.set_frequency_range(0, self.tx_rate)

    def get_tx_freq(self):
        return self.tx_freq

    def set_tx_freq(self, tx_freq):
        self.tx_freq = tx_freq
        self.osmosdr_sink_0.set_center_freq(self.tx_freq, 0)

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate

    def get_rf_gain(self):
        return self.rf_gain

    def set_rf_gain(self, rf_gain):
        self.rf_gain = rf_gain
        self.osmosdr_sink_0.set_gain(self.rf_gain, 0)

    def get_mpx_rate(self):
        return self.mpx_rate

    def set_mpx_rate(self, mpx_rate):
        self.mpx_rate = mpx_rate
        self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.mpx_rate, 15000, 2000, window.WIN_HANN, 6.76))
        self.qtgui_freq_sink_x_0.set_frequency_range(0, self.mpx_rate)

    def get_if_gain(self):
        return self.if_gain

    def set_if_gain(self, if_gain):
        self.if_gain = if_gain
        self.osmosdr_sink_0.set_if_gain(self.if_gain, 0)

    def get_bb_gain(self):
        return self.bb_gain

    def set_bb_gain(self, bb_gain):
        self.bb_gain = bb_gain
        self.osmosdr_sink_0.set_bb_gain(self.bb_gain, 0)

    def get_audio_gain(self):
        return self.audio_gain

    def set_audio_gain(self, audio_gain):
        self.audio_gain = audio_gain
        self.blocks_multiply_const_vxx_0.set_k(self.audio_gain)
        self.blocks_multiply_const_vxx_1.set_k(self.audio_gain)




def main(top_block_cls=fm_tx, options=None):

    if StrictVersion("4.5.0") <= StrictVersion(Qt.qVersion()) < StrictVersion("5.0.0"):
        style = gr.prefs().get_string('qtgui', 'style', 'raster')
        Qt.QApplication.setGraphicsSystem(style)
    qapp = Qt.QApplication(sys.argv)

    tb = top_block_cls()

    tb.start()

    tb.show()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        Qt.QApplication.quit()

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    timer = Qt.QTimer()
    timer.start(500)
    timer.timeout.connect(lambda: None)

    qapp.exec_()

if __name__ == '__main__':
    main()
